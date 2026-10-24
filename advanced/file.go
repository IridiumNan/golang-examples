// Description: This program shows how to read and write files in Go
// Tags: file, read, write, file read, file write, file read wr
package main

import (
	"fmt"
	"log/slog"
	"os"
	"path"
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

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {
	// change directory to ensure file found
	cdRootDir()
	cdAdvanced()

	filename := "./file.go"

	// os.Stat returns file info
	finfo, err := os.Stat(filename)
	if err != nil {
		fmt.Println(filename + " doesn't exist")
	} else {
		// IsDir returns boolean true if finfo is a directory
		if finfo.IsDir() {
			fmt.Println(filename + " is a directory")
		} else {

			// ReadFile returns the input of the file
			gofile, err1 := os.ReadFile(filename)
			check(err1)
			output := []byte(gofile)
			fmt.Println(string(gofile))

			// WriteFile writes data to a file
			err2 := os.WriteFile("./file.txt", output, 0o644)
			check(err2)
		}
	}
}
