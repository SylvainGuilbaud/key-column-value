Class data.myREST Extends %CSP.REST
{

ClassMethod test(name As %String = "World") As %Status [ SqlProc ]
{
    set sc = $$$OK
    set %response.ContentType = ..#CONTENTTYPEJSON
    if $ISOBJECT(%request.Content) {
        set json = {}.%FromJSON(%request.Content.Read())
    } else {
        set json={
            "Hello":(name)
        }
    }
    write json.%ToJSON()
    #; set sc = $system.Status.Error(5001,"Erreur TDA")

    #; set %response.Status=500
    do ##class(%REST.Impl).%SetStatusCode(..#HTTP401UNAUTHORIZED)

    Return sc
}

ClassMethod testPOST() As %Status [ SqlProc ]
{
    set sc = $$$OK
    set resultat = {
        "Hello":(name)
    }
    write resultat.%ToJSON()
    #; write "Hello ",name,!

    Return sc
}

ClassMethod get(name As %String = "Lucie") As %String
{
    Try {
    
        set status = ""
        set httpRequest = ##class(%Net.HttpRequest).%New()
        set httpRequest.Server = "host.docker.internal"
        set httpRequest.Port = 60000
        set httpRequest.Username = "_system"
        set httpRequest.Password = "SYS"
        set httpRequest.Timeout = 5

        set sc = httpRequest.Get("http://" _ httpRequest.Server _ ":" _ httpRequest.Port _ "/myAPI/test/" _ name)
        if $$$ISOK(sc) && $IsObject(httpRequest.HttpResponse.Data) {
            set resultat = httpRequest.HttpResponse.Data.Read()
            set status = httpRequest.HttpResponse.StatusCode
        }

        #; set sc = httpRequest.Post("http://" _ httpRequest.Server _ ":" _ httpRequest.Port _ "/common/import/" _ classname)
        #; if $$$ISOK(sc) && $IsObject(httpRequest.HttpResponse.Data) {
        #;     set ^post($i(^post)) = httpRequest.HttpResponse.Data.Read()
        #;     set status = httpRequest.HttpResponse.StatusCode
        #; } 
        #; set ^post($i(^post)) = $SYSTEM.Status.GetErrorCodes(sc)
        #; set ^post($i(^post)) = $SYSTEM.Status.GetErrorText(sc)
    

        #; write i, " status:" , status,!
    }
    Catch ex {
        Set sc = ex.AsStatus()
    }
    return resultat
}

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/test" Method="GET" Call="test" Cors="true"/>
<Route Url="/test/:name" Method="GET" Call="test" Cors="true"/>
<Route Url="/test" Method="POST" Call="test" Cors="true"/>
</Routes>
}

}
