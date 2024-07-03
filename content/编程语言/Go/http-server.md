# 创建 http 服务器
```go
package main
import "net/http"
func hello(w http.ResponseWriter, r *http.Request){
	w.Write([]byte("Hello\n"))
}
func main(){
	http.HandleFunc("/",hello)
	http.ListenAndServer(":8000",nil)
}
```

# 路由
```go
http:HandleFunc("/",hello)
http:HandleFunc("/admin",admin)
http:HandleFunc("/user",user)
```