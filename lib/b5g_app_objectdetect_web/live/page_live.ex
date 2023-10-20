defmodule B5gAppObjectdetectWeb.PageLive do
  use B5gAppObjectdetectWeb, :live_view
  alias Giocci
  require Logger

  @default_model "320"
  @default_backend "local"

  def mount(_params, _session, socket) do
    use_giocci = System.get_env("USE_GIOCCI") |> Code.eval_string |> elem(0)
    backend_options =
      case use_giocci do
        true -> ["local", "mec", "sakura", "aws"]
        _ -> ["local"]
      end

    {:ok, assign(socket,
      backend_options: backend_options,
      detecting: false,
      data_url: "",
      processing_time: "",
      detected_data: [],
      ref: nil,
      total_time: nil,
      model: @default_model,
      backend: @default_backend,
      form: to_form(%{
        "model" => @default_model,
        "backend" => @default_backend
      })
    )}
  end

  def handle_event("form_changed", params, socket) do
    {:noreply, assign(socket, model: params["model"], backend: params["backend"], form: to_form(params))}
  end

  def handle_event("detect", %{"data_url" => data_url}, socket) do
    start_time = DateTime.utc_now()

    task = Task.async(fn ->
      %{"base64_data" => base64_data} =
        Regex.named_captures(~r/base64,(?<base64_data>.*)/, data_url)

      binary = Base.decode64!(base64_data)
      model = socket.assigns.model
      backend = socket.assigns.backend

      {processing_time, detected_data} = detect(binary, model, backend)

      detected_binary = draw_bbox(binary, detected_data)
      detected_data_url = "data:image/jpeg;base64," <> Base.encode64(detected_binary)
      {processing_time, detected_data, detected_data_url}
    end)

    {:noreply, assign(
      socket,
      detecting: true,
      data_url: "",
      processing_time: "",
      detected_data: [],
      ref: task.ref,
      start_time: start_time,
      total_time: nil
    )}
  end

  def handle_info({ref, result}, socket) when socket.assigns.ref == ref do
    {processing_time, detected_data, detected_data_url} = result
    total_time = DateTime.diff(DateTime.utc_now(), socket.assigns.start_time, :microsecond)
    Logger.info("total_time: #{total_time / 10 ** 6}")
    Logger.info("processing_time: #{processing_time / 10 ** 6}")
    {:noreply, assign(
      socket,
      detecting: false,
      data_url: detected_data_url,
      processing_time: processing_time / 10 ** 6,
      detected_data: detected_data,
      ref: nil,
      start_time: nil,
      total_time: total_time / 10 ** 6
    )}
  end

  def handle_info(_, socket) do
    {:noreply, socket}
  end

  defp detect(binary, model, "local") do
    backend = System.get_env("DEFAULT_BACKEND_SERVER") |> Code.eval_string |> elem(0)
    GenServer.call(backend, {:detect, binary: binary, model: model}, 180000)
  end

  defp detect(binary, model, backend) do
    Giocci.detect({:detect, binary: binary, model: model}, String.to_atom(backend))
  end

  defp draw_bbox(binary, []), do: binary
  defp draw_bbox(binary, detected_data) do
    img = Evision.imdecode(binary, Evision.Constant.cv_IMREAD_COLOR())

    bbox_img =
      detected_data
      |> Enum.reduce(img, fn %{"box" => box, "class" => class, "score" => score}, drawed_mat ->
        # 座標情報は整数に変換。
        [left, top, right, bottom] = Enum.map(box, &trunc(&1))

        # スコアは小数点以下3桁の文字列に変換する
        score = Float.round(score, 3) |> Float.to_string()

        drawed_mat
        |> Evision.rectangle(
          {left, top},
          {right, bottom},
          {255, 0, 0},
          thickness: 4
        )
        |> Evision.putText(
          class <> ":" <> score,
          {left + 6, top + 26},
          Evision.Constant.cv_FONT_HERSHEY_SIMPLEX(),
          1,
          {0, 0, 255},
          thickness: 2
        )
      end)

    Evision.imencode(".jpg", bbox_img)
  end
end
