Class data.result Extends (%Persistent, %JSON.Adaptor, %XML.Adaptor, %Populate)
{

Property key As %Integer(MINVAL = 1);

Property column As data.column;

Property value As %String(MAXLEN = "", POPSPEC = "##class(data.result).popValue()");

Index keyColumn On (key, column) [ Data = value, Unique ];

Index columnIndex On column [ Type = bitmap ];

ClassMethod init(nb As %Integer = 1000, reset As %Boolean = 1) As %Status
{
    Set sc = $$$OK
    if reset {
        set sc = ..%KillExtent()
        set nbColumns = ##class(data.column).init()
        kill ^backupdata.resultD,^backupdata.resultI,^backupdata.resultS
    }
    set rs = ##class(%SQL.Statement).%ExecDirect(,"select name from data.column")
    set columnList = ""
    while rs.%Next() {
        set columnList = columnList _ $lb(rs.%Get("name"))
    }
    for i = 1:1:nb {
        for j = 1:1:$ll(columnList) {
            set result = ..%New()
            set result.key = i
            set result.column = ##class(data.column).%OpenId($lg(columnList,j))
            set result.value = ..popValue()
            set sc = result.%Save()
        }
    }
    #; do ..Populate(nb)

    &SQL(select count(*) into :nbResults from data.result)
    write !,nbResults," inserted in ",..%ClassName(1),!
    #; write "backing up data.result...",!
    #; merge ^backupdata.resultD = ^data.resultD
    #; merge ^backupdata.resultI = ^data.resultI
    #; merge ^backupdata.resultS = ^data.resultS
    #; write "data.result globals merged in ^backupdata.result*",!
    
    #; kill ^data.result
    #; set ^data.result(1,"Nom") = "LI PUMA"
    #; set ^data.result(1,"Prenom") = "Claude"
    #; set ^data.result(1,"IBAN") = "1111-444-55566"
    #; set ^data.result(2,"Marque") = "Renault"
    #; set ^data.result(2,"Couleur") = "Bleue"
    #; set ^data.result(2,"Phone") = "223-4445-555"
    #; set ^data.result(3,"Marque") = "Renault"
    #; set ^data.result(3,"Couleur") = "Noire"
    #; set ^data.result(3,"Phone") = "223-4445-555"
    #; set ^data.result(4,"Marque") = "Toyota"
    #; set ^data.result(4,"Couleur") = "Noire"
    #; set ^data.result(4,"Phone") = "223-4445-555"
    #; zw ^data.result
    Return sc
}

ClassMethod popValue() As %String
{
    set t1=$lb("Rouge","Vert","Bleu","Jaune","Noir","Blanc","Orange","Violet","Parme","Prune","Marron","Gris","Rose","Fuschia","Crème","Cuivre","Fumée","Glycine","Framboise")
    return $li(t1,$$$PRand($ll(t1))+1)
}

ClassMethod popColumn(ByRef list) As %String
{
  
    #; set t1=$lb("Rouge","Vert","Bleu","Jaune","Noir","Blanc","Orange","Violet","Parme","Prune","Marron","Gris","Rose","Fuschia","Crème","Cuivre","Fumée","Glycine","Framboise")
    return $li(list,$$$PRand($ll(list))+1)
}

ClassMethod get(search As %String = "Renault", columnName As %String = "Marque") As %DynamicArray
{
    set key="",json=[]
    SET key=$ORDER(^data.result(""))
    WHILE (key'="") {
        #; WRITE key,!
        if $Get(^data.result(key,columnName)) = search {
            write key,!
            set data={}
            set data.id=key
            set column = ""

            set column = $ORDER(^data.result(key,column),1,target)

            set data.contents={}
            set data.contents.column=(column)
            set data.contents.value=(target)
    
            do json.%Push(data)
             
        }
        // Get next subscript
        SET key = $ORDER(^data.result(key))
    }
    Return json
}

Query data(globalName As %String) As %Query(ROWSPEC = "ID:%String,key2:%String,key3:%String,key4:%String,key5:%String,key6:%String,datavalue:%String") [ SqlProc ]
{
}

ClassMethod dataExecute(ByRef qHandle As %Binary, globalName As %String) As %Status
{
    Set qHandle("node") = globalName
    Quit $$$OK
}

ClassMethod dataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Boolean) As %Status [ PlaceAfter = dataExecute ]
{
    Set sc = $$$OK
    Set qHandle("node") = $Query(@qHandle("node"), 1, data)
    If qHandle("node") = "" Set Row = "", AtEnd = $$$YES Quit $$$OK
    ; feeds the key x fields based on the subscripts of the global
    For i=1:1:$QLength(qHandle("node")) Set $List(Row, i) = $QSubscript(qHandle("node"), i)
    If i < 6 { ; if we do not have 6 subscripts, we feed the rest with an empty string
    For j = i+1:1:6 Set $List(Row, j) = ""
    }

    Set $List(Row, 7) = data, AtEnd = $$$NO
    Quit sc
}

ClassMethod dataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = dataExecute ]
{
    Kill qHandle Quit $$$OK
}

Storage Default
{
<Data name="resultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>key</Value>
</Value>
<Value name="3">
<Value>column</Value>
</Value>
<Value name="4">
<Value>value</Value>
</Value>
</Data>
<DataLocation>^data.resultD</DataLocation>
<DefaultData>resultDefaultData</DefaultData>
<IdLocation>^data.resultD</IdLocation>
<IndexLocation>^data.resultI</IndexLocation>
<StreamLocation>^data.resultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
