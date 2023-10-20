const DetectButton = {
  mounted() {
    const video = document.querySelector("#video");
    if (video) {

      this.handleEvent("detect", ({ data_url: dataUrl }) => {
        const image = document.querySelector("#image");
        image.setAttribute("src", dataUrl);
      });

      navigator.mediaDevices
        .getUserMedia({
          video: {
            facingMode: "user",
            width: { ideal: 1920 },
            height: { ideal: 1080 },
          },
          audio: false,
        })
        .then(stream => {

          video.srcObject = stream;

          const [track] = stream.getVideoTracks();
          const settings = track.getSettings();
          const { width, height } = settings;

          this.el.addEventListener("click", event => {
            const canvas = document.createElement("canvas");
            canvas.setAttribute("width", width);
            canvas.setAttribute("height", height);

            const context = canvas.getContext("2d");
            context.translate(width, 0);
            context.scale(-1, 1);
            context.drawImage(video, 0, 0, width, height);

            const dataUrl = canvas.toDataURL("image/jpeg");

            this.pushEvent("detect", { data_url: dataUrl });
          });
        })
        .catch(error => {
          console.error("Error accessing webcam:", error);
        });
    }
  }
};

export default DetectButton;
