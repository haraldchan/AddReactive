class useImages {
    /**
     * Creates a image repo to access image paths.
     * @param {String} folderPath 
     */
    __New(folderPath) {
        this.folderPath := folderPath
        this.imageExtends := ["jpg", "jpeg", "gif", "png", "tiff", "bmp", "ico"]
        this.imageList := OrderedMap()

        this.load()
    }

    __Item[key] {
        get => this.imageList[StrLower(key)].fullpath
    }

    load() {
        this.imageList.clear()

        loop files, this.folderPath . "\*.*" {
            if (ArrayExt.find(this.imageExtends, ext => ext == StrLower(A_LoopFileExt))) {
                this.imageList[StrLower(A_LoopFileName)] := {
                    name: A_LoopFileName,
                    ext: A_LoopFileExt,
                    fullPath: A_LoopFileFullPath,
                    shortPath: A_LoopFileShortPath,
                    timeModified: A_LoopFileTimeModified,
                    timeCreated: A_LoopFileTimeCreated,
                    timeAccessed: A_LoopFileTimeAccessed,
                    size: A_LoopFileSize,
                    sizeKB: A_LoopFileSizeKB,
                    sizeMB: A_LoopFileSizeMB
                }
            }
        }
    }

    use(filename) {
        return this.imageList[filename]
    }
}
