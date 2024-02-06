Class data.column Extends (%Persistent, %JSON.Adaptor, %XML.Adaptor)
{

Property name As %String;

Index key On name [ IdKey ];

/// Description
ClassMethod init() As %Integer
{
    Set sc = $$$OK
    do ..%KillExtent()
    for name = 
        "Marque"
        ,"Couleur"
        ,"Priorité"
        ,"Adresse"
        ,"Adresse Pro"
        ,"Adresse Personnelle"
        ,"Adresse Bureau"
        ,"Adresse Principale"
        ,"IBAN"
        ,"IBAN Pro"
        ,"IBAN Personnel"
        ,"IBAN Principal"
        ,"Mobile"
        ,"Mobile Pro"
        ,"Mobile Personnel"
        ,"Téléphone Bureau"
        ,"Téléphone Mobile"
        ,"Téléphone Pro"
        ,"Téléphone Personnel"
        ,"Téléphone Principal"
        ,"Email"
        ,"Email Bureau"
        ,"Email Pro"
        ,"Email Personnel"
        ,"Email Principal"
        ,"Nom"
        ,"Description"
        ,"Etat"
        ,"Rubrique"
        ,"Poids"
        ,"Poids Max"
        ,"Poids Min"
        ,"Poids Moyenne"
        ,"Densité"
        ,"Densité Min"
        ,"Densité Max"
        ,"Densité Moyenne"
        ,"Charge"
        ,"Charge Min"
        ,"Charge Max"
        ,"Charge Moyenne"
        ,"Unité"
        ,"Capacité"
        ,"Capacité Max"
        ,"Capacité Min"
        ,"Capacité Moyenne"
        ,"Valeur"
        ,"Valeur Min"
        ,"Valeur Max"
        ,"Valeur Moyenne"
        {
        set column = ..%New()
        set column.name = name
        set sc = column.%Save()
    }
    &SQL(select count(*) into :nb from data.column)
    write nb," inserted in ",..%ClassName(1),!
    Return nb
}

Storage Default
{
<Data name="columnDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^data.columnD</DataLocation>
<DefaultData>columnDefaultData</DefaultData>
<IdLocation>^data.columnD</IdLocation>
<IndexLocation>^data.columnI</IndexLocation>
<StreamLocation>^data.columnS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
