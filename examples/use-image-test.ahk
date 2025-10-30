#SingleInstance Force
#Include "../useAddReactive.ahk"

g := Gui()
UseImageTest(g)
g.Show()

UseImageTest(App) {
	Images := useImages("c:\Users\haraldchan\Pictures\Screenshots")

	imgList := Images.imageList.values().map(i => i.fullpath)
	filenameList := Images.imageList.values().map(i => i.name)

	index := signal(1)
	curImage := signal(imgList[1])

	effect(index, curIndex => (
		curImage.set(imgList[curIndex])
		App["filename"].Choose(Integer(curIndex))
	))

	handleImageFlip(ctrl, _) {
		if (ctrl.Text == "prev") {
			index.set(p => p - 1 == 0 ? 1 : p - 1)
		} else {
			index.set(p => p + 1 > imgList.Length ? imgList.Length : p + 1)
		}
	}

	return (
		App.AddDDL("vfilename x20 w300 Choose1", filenameList)
		   .OnEvent("Change", (ctrl, _) => curImage.set(Images[ctrl.Text])),

		App.AREdit("x20 w100 Number", "{1}", index)
		   .OnEvent("LoseFocus", (ctrl, _) => index.set(ctrl.Value)),

		App.AddButton("x20 w50", "prev").OnEvent("Click", handleImageFlip),
		App.AddButton("x+10 w50", "next").OnEvent("Click", handleImageFlip),

		App.ARPic("x20 w200 h-1", curImage)
		   .OnEvent("DoubleClick", (*) => Run(curImage.value))
	)
}