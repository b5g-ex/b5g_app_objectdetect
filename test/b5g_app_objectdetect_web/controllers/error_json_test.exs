defmodule B5gAppObjectdetectWeb.ErrorJSONTest do
  use B5gAppObjectdetectWeb.ConnCase, async: true

  test "renders 404" do
    assert B5gAppObjectdetectWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert B5gAppObjectdetectWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
