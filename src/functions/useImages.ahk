class useImages {
    /**
     * Creates a image repo to access image paths.
     * @param {String} folderPath 
     */
    __New(folderPath) {
        this.folderPath := folderPath
        this.imgExtends := ["jpg", "jpeg", "gif", "png", "tiff", "bmp", "ico"]
        this.imgList := Map()

        loop files, folderPath . "\*.*" {
            if (this.imgExtends.find(ext => ext == A_LoopFileExt.toLower())) {
                this.imgList[StrLower(A_LoopFileName)] := A_LoopFileFullPath
            }
        }
    }

    __Item[key] {
        get => this.imgList[StrLower(key)]
    }
}