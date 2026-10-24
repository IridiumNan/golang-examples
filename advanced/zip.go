package main

import (
	"archive/zip"
	"fmt"
	"io"
	"log"
	"log/slog"
	"os"
	"path"
	"path/filepath"
	"strings"
)

const rootDir = "golang-examples"

// cdRootDir is a uitl function to change dir into project root
// to ensure example.zip can be found properly
func cdRootDir() {
	dir, err := os.Getwd()
	if err != nil {
		slog.Warn("while getting current dir for find archive file, assume current dir as project root", "err", err)
		slog.Info("if run failed, change your dir to golang-example first")
		return
	}
	for path.Base(dir) != rootDir {

		slog.Info("current dir is not root dir, change to parent dir", "curr", dir)
		err = os.Chdir("..")
		if err != nil {
			slog.Error("while change dir", "err", err)
		}
	}
}

func cdAdvanced() {
	err := os.Chdir("advanced")
	if err != nil {
		slog.Error("while changing dir to advanced", "err", err)
		slog.Info("if you want to run this file manually, comment the `cdRootDir` and `cdAdvanced` function call on main")
	}
}

func ZipContent(file string) []string {
	var filenames []string
	archive, err := zip.OpenReader(file)
	if err != nil {
		panic(err)
	}
	defer archive.Close()

	for _, f := range archive.File {
		if f.Name[0:1] == "." {
			// hide hidden files
			continue
		}
		filenames = append(filenames, f.Name)
	}
	return filenames
}

func UnzipAll(file string, dest string) {
	archive, err := zip.OpenReader(file)
	if err != nil {
		panic(err)
	}
	defer archive.Close()

	for _, f := range archive.File {
		filePath := filepath.Join(dest, f.Name)
		fmt.Println("unzipping file ", filePath)

		if !strings.HasPrefix(filePath, filepath.Clean(dest)+string(os.PathSeparator)) {
			fmt.Println("invalid file path")
			return
		}
		if f.FileInfo().IsDir() {
			fmt.Println("creating directory...")
			os.MkdirAll(filePath, os.ModePerm)
			continue
		}

		if err := os.MkdirAll(filepath.Dir(filePath), os.ModePerm); err != nil {
			panic(err)
		}

		dstFile, err := os.OpenFile(filePath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, f.Mode())
		if err != nil {
			panic(err)
		}

		defer dstFile.Close()

		fileInArchive, err := f.Open()
		if err != nil {
			panic(err)
		}

		defer fileInArchive.Close()

		if _, err := io.Copy(dstFile, fileInArchive); err != nil {
			panic(err)
		}

	}
}

func ReadZipped(zipFile, file string) string {
	archive, err := zip.OpenReader(zipFile)
	if err != nil {
		panic(err)
	}
	defer archive.Close()

	for _, f := range archive.File {
		if f.Name != file {
			continue
		}

		fileInArchive, err := f.Open()
		if err != nil {
			panic(err)
		}
		defer fileInArchive.Close()

		data, err := io.ReadAll(fileInArchive)
		if err != nil {
			log.Fatal(err)
		}

		return string(data)
	}
	return ""
}

func main() {
	// change dir for find the zip package
	cdRootDir()
	cdAdvanced()

	files := ZipContent("example.zip")

	fmt.Printf("%#v\n", files)

	content := ReadZipped("example.zip", files[2])
	fmt.Printf("%#v\n", content)

	UnzipAll("example.zip", "output")
}
