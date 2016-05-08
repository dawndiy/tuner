import QtQuick 2.4
import Ubuntu.Components 1.3

Canvas {
    id: dashboard

    function drawSpectrum(frequencyList, amplitudeList) {

        var ctx = getContext("2d")

        ctx.clearRect(0, 0, width, height)

        for (var i in frequencyList) {
            // console.log(frequencyList[i], amplitudeList[i]);
            var h = amplitudeList[i] * height
            ctx.fillRect(i, height-h, 1, height)
        }

        requestPaint()

    }

    function drawDashboard(value) {

        var x0 = width / 2
        var y0 = height
        var r = width / 2 - units.gu(2)

        var ctx = getContext("2d")
        ctx.clearRect(0, 0, width, height)

//        ctx.beginPath();
//        ctx.rect(0, 0, width, height)
//        ctx.closePath()
//        ctx.stroke()

        ctx.beginPath();
        ctx.arc(x0, y0, units.gu(1), 0, Math.PI*2, false)
        ctx.closePath();
        ctx.stroke()

        ctx.beginPath();
        ctx.arc(x0, y0, r, -Math.PI/180*45, -Math.PI/180*135, true)
        ctx.lineWidth = units.gu(0.5)
        ctx.stroke()

        for (var i=0; i<91; i += 15) {
            var o = i + 45
            var x1 = r * Math.cos(-Math.PI/180*o) + x0
            var y1 = r * Math.sin(-Math.PI/180*o) + y0

            var x2 = (r-units.gu(1)) * Math.cos(-Math.PI/180*o) + x0
            var y2 = (r-units.gu(1)) * Math.sin(-Math.PI/180*o) + y0

            ctx.beginPath();
            ctx.moveTo(x1, y1)
            ctx.lineTo(x2, y2)
            ctx.lineWidth = units.gu(0.2);
            ctx.stroke();
        }

        //var value = 0;

        ctx.beginPath()
        ctx.moveTo(x0, y0)

        var po = value
        var x = r * Math.cos(-Math.PI/180*po) + x0
        var y = r * Math.sin(-Math.PI/180*po) + y0

        ctx.lineTo(x, y)
        ctx.stroke()

        requestPaint()

    }

    onPaint: {
        // drawDashboard(123)
    }
}

