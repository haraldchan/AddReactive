#SingleInstance Force
#Include "../useAddReactive.ahk"

g := Gui()
UseImageTest(g)
g.Show()

UseImageTest(App) {
	Images := useImages("C:\Users\swan\Pictures")

	imgList := Images.imageList.values().map(i => i.fullpath)
	filenameList := Images.imageList.values().map(i => i.name)

	ptr := signal(1)
	curImage := signal(imgList[1])

	effect(ptr, curPtr => (
		curImage.set(imgList[curPtr])
		App["filename"].Choose(curPtr)
	))

	handleImageFlip(ctrl, _) {
		if (ctrl.Text == "prev") {
			ptr.set(p => p - 1 == 0 ? 1 : p - 1)
		} else {
			ptr.set(p => p + 1 > imgList.Length ? imgList.Length : p + 1)
		}
	}

	return (
		App.AddDDL("vfilename x20 w100 Choose1", filenameList)
		   .OnEvent("Change", (ctrl, _) => curImage.set(Images[ctrl.Text])),

		App.AREdit("x20 w100 Number", "{1}", ptr)
		   .OnEvent("LoseFocus", (ctrl, _) => ptr.set(ctrl.Value)),

		App.AddButton("x20 w50", "prev").OnEvent("Click", handleImageFlip),
		App.AddButton("x+10 w50", "next").OnEvent("Click", handleImageFlip),

		App.ARPic("x20 w200 h-1", curImage)
		   .OnEvent("DoubleClick", (*) => Run(curImage.value))
	)
}