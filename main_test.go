package main

import (
	"encoding/json"
	"errors"
	"io"
	"net/http/httptest"
	"testing"

	. "github.com/smartystreets/goconvey/convey"
)

func TestHandleError(t *testing.T) {
	Convey("HandleError should panic", t, func() {
		So(func() {
			HandleError("Payload", errors.New("panic value"))
		}, ShouldPanic)
	})

	Convey("HandleError should not panic", t, func() {
		So(func() {
			HandleError("Payload", nil)
		}, ShouldNotPanic)
	})
}

func TestEnvHandler(t *testing.T) {
	Convey("HandleError should panic", t, func() {
		w := httptest.NewRecorder()
		EnvHandler(w, nil)
		resp := w.Result()
		So(resp, ShouldNotBeNil)
		body, _ := io.ReadAll(resp.Body)
		m := map[string]string{}
		err := json.Unmarshal(body, &m)
		So(err, ShouldBeNil)
		So(m, ShouldContainKey, "PATH")
		So(m, ShouldContainKey, "USER")
	})
}
