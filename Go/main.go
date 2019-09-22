/*
 * Poly2Tri Copyright (c) 2009-2011, Poly2Tri Contributors
 * http://code.google.com/p/poly2tri/
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * * Neither the name of Poly2Tri nor the names of its contributors may be
 *   used to endorse or promote products derived from this software without specific
 *   prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package main

import (
	"fmt"
	"os"
	"flag"
	"p2t"
	"gl"
	"gl/glu"
	"sdl"
	"strings"
	"io/ioutil"
	"strconv"
	"time"
)

const (
	Title  = "Poly2Tri Demo"
	Width  = 640
	Height = 480
)

var running bool
var filename *string
var cx, cy *int
var zoom *float64

var left, right, bottom, top float64

func main() {

	filename = flag.String("file", "testbed/data/dude.dat", "enter filename path")
	cx = flag.Int("cx", 300, "enter x-coordinate center")
	cy = flag.Int("cy", 500, "enter y-coordinate center")
	zoom = flag.Float64("zoom", 2, "enter zoom")

	flag.Parse()

	fmt.Println("opening...", *filename)
	f, err := os.Open(*filename)
	if f == nil {
		fmt.Fprintf(os.Stderr, "cat: can't open %s: error %s\n", *filename, err)
		os.Exit(1)
	}

	d, _ := ioutil.ReadAll(f)
	line := strings.SplitAfter(string(d), "\n")

	j := 0
	for i := 0; i < len(line); i++ {
		if len(line[i]) <= 2 {
			break
		}
		j++
	}

	var polyline = make(p2t.PointArray, j)
	for i := 0; i < j; i++ {
		line[i] = strings.TrimRight(line[i], "\r\n")
		num := strings.Split(line[i], " ")
		n1, err1 := strconv.Atof64(num[0])
		n2, err2 := strconv.Atof64(num[1])
		if err1 != nil || err2 != nil {
			fmt.Fprintf(os.Stderr, "cat: can't open %s: error %s\n", *filename, err)
			os.Exit(1)
		}
		polyline[i] = &p2t.Point{X: n1, Y: n2}
	}

	f.Close()

	left = -Width / float64(*zoom)
	right = Width / float64(*zoom)
	bottom = -Height / float64(*zoom)
	top = Height / float64(*zoom)

	last_time := time.Nanoseconds()
	
	p2t.Init(polyline)
	var triangles p2t.TriArray = p2t.Triangulate()

	dt := time.Nanoseconds() - last_time	
	fmt.Printf("Elapsed time : %f ms\n", float64(dt)*1e-6)
	
	//var mesh p2t.TriArray = p2t.Mesh()

	sdl.Init(sdl.INIT_VIDEO)

	var screen = sdl.SetVideoMode(Width, Height, 16, sdl.OPENGL|sdl.RESIZABLE)

	if screen == nil {
		sdl.Quit()
		panic("Couldn't set GL video mode: " + sdl.GetError() + "\n")
	}

	sdl.WM_SetCaption("Pol2tri - testbed", "poly2tri")

	if gl.Init() != 0 {
		panic("gl error")
	}

	initGL()

	done := false
	for !done {
		for e := sdl.PollEvent(); e != nil; e = sdl.PollEvent() {
			switch e.(type) {
			case *sdl.ResizeEvent:
				re := e.(*sdl.ResizeEvent)
				screen = sdl.SetVideoMode(int(re.W), int(re.H), 16,
					sdl.OPENGL|sdl.RESIZABLE)
				if screen != nil {
					reshape(int(screen.W), int(screen.H))
				} else {
					panic("we couldn't set the new video mode??")
				}
				break

			case *sdl.QuitEvent:
				done = true
				break
			}
		}
		keys := sdl.GetKeyState()

		if keys[sdl.K_ESCAPE] != 0 {
			done = true
		}
		resetZoom()
		draw(triangles)
	}
	sdl.Quit()
	return

}

func reshape(w, h int) {
	if h == 0 {
		h = 1
	}
	gl.Viewport(0, 0, w, h)
	gl.MatrixMode(gl.PROJECTION)
	gl.LoadIdentity()
	glu.Perspective(45.0, float64(w)/float64(h), 0.1, 100.0)
	gl.MatrixMode(gl.MODELVIEW)
	gl.LoadIdentity()
	resetZoom()
}

func resetZoom() {
	// Reset viewport
	gl.LoadIdentity()
	gl.MatrixMode(gl.PROJECTION)
	gl.LoadIdentity()

	// Reset ortho view
	gl.Ortho(left, right, bottom, top, 1, -1)
	gl.Rotatef(180, 0, 0, 0)
	gl.Translatef(float32(-*cx), float32(-*cy), 0)
	gl.MatrixMode(gl.MODELVIEW)
	gl.Disable(gl.DEPTH_TEST)
	gl.LoadIdentity()
}

func initGL() {
	gl.ShadeModel(gl.SMOOTH)
	gl.ClearColor(0, 0, 0, 0)
	gl.ClearDepth(1)
	gl.Enable(gl.DEPTH_TEST)
	gl.DepthFunc(gl.LEQUAL)
	gl.Hint(gl.PERSPECTIVE_CORRECTION_HINT, gl.NICEST)
}

func draw(triangles p2t.TriArray) {

	gl.Clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)

	for i := 0; i < len(triangles); i++ {
		var t = triangles[i]
		var a = t.Point[0]
		var b = t.Point[1]
		var c = t.Point[2]

		// Red
		gl.Color3f(1, 0, 0)

		gl.Begin(gl.LINE_LOOP)
		gl.Vertex2f(float32(a.X), float32(a.Y))
		gl.Vertex2f(float32(b.X), float32(b.Y))
		gl.Vertex2f(float32(c.X), float32(c.Y))
		gl.End()
	}

	sdl.GL_SwapBuffers()
}

func drawMap(cx, cy, zoom float64, triangles p2t.TriArray) {

	for i := 0; i < len(triangles); i++ {
		t := triangles[i]
		a := t.Point[0]
		b := t.Point[1]
		c := t.Point[2]

		//constrainedColor(t.constrained_edge[2])
		gl.Begin(gl.LINES)
		gl.Vertex2f(float32(a.X), float32(a.Y))
		gl.Vertex2f(float32(b.X), float32(b.Y))
		gl.End()

		//constrainedColor(t.constrained_edge[0])
		gl.Begin(gl.LINES)
		gl.Vertex2f(float32(b.X), float32(b.Y))
		gl.Vertex2f(float32(c.X), float32(c.Y))
		gl.End()

		//constrainedColor(t.constrained_edge[1])
		gl.Begin(gl.LINES)
		gl.Vertex2f(float32(c.X), float32(c.Y))
		gl.Vertex2f(float32(a.X), float32(a.Y))
		gl.End()
	}
}

func constrainedColor(constrain bool) {
	if constrain {
		// Green
		gl.Color3f(0, 1, 0)
	} else {
		// Red
		gl.Color3f(1, 0, 0)
	}
}
