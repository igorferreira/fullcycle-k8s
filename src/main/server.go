package main

import "net/http"

func main() {

	http.HandleFunc("/", home)
	http.ListenAndServe(":3000", nil)
}

func home(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("<h1>Ola porra</h1>"))
}
