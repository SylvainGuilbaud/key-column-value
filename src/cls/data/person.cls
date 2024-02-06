Class data.person Extends %Persistent [ StorageStrategy = NewStorage1 ]
{

Property nom As %String;

Property prenom As %String;

Property KEY As %Integer;

Property dateDebut As %Date(FORMAT = 4);

Property allergique As %Boolean [ InitialExpression = 0 ];

Property distance As %Double(SCALE = 3);

Index Master On KEY [ IdKey ];

ClassMethod pop() As %Status
{
    Set sc = $$$OK
    set ^data.person(1) = "David,MARINKOVIC,60000,1,123.67"
    set ^data.person(2) = "Claude,LI PUMA,57000,0,456.89"
 
    Return sc
}

/// Description
ClassMethod getTop1() As %String [ SqlProc ]
{
    &SQL(select top 1 nom into :prenom from data.person order by prenom desc)
    Return prenom
}

/// Description
ClassMethod getPython() As %String [ Language = python ]
{
import iris
nom = iris.cls("data.person").getTop1()
print(nom)
return 1
}

ClassMethod getMapping(id As %Integer) As data.person [ Language = python ]
{
import iris
mapping = iris.cls("data.person")._OpenId(id)
return mapping
}

/// Description
Query list() As %SQLQuery [ SqlProc ]
{
    SELECT top 1 *
    FROM data.person
    order by prenom
}

/// Description
ClassMethod list2() As %Status
{
    Set sc = $$$OK
    set sql="select top 1 * from data.person order by prenom desc"
    set statement = ##class(%SQL.Statement).%New()
    set status = statement.%Prepare(sql) 
    if $$$ISOK(status) {
        set rs = statement.%Execute()
        if ( rs.%SQLCODE '= 0 ) {
            if (rs.%SQLCODE = 100) {
                #; do ..%SetStatusCode("404")
            } else {            
                #; do ..%SetStatusCode("500")
            }
            set sc = $$$ERROR($$$SQLCode,SQLCODE,$g(%msg))
        }
    }
    Return sc
}

/// Every class can only have 1 active Storage Definition.  
/// Each Storage Definition can have more than one map.
Storage NewStorage1
{
<Description>
<![CDATA[Every class can only have 1 active Storage Definition.  
Each Storage Definition can have more than one map.]]></Description>
<SQLMap name="SimpleDataMap">
<Data name="allergique">
<Delimiter>","</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="dateDebut">
<Delimiter>","</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="distance">
<Delimiter>","</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="nom">
<Delimiter>","</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="prenom">
<Delimiter>","</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^data.person</Global>
<Subscript name="1">
<Expression>{KEY}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^data.personS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
