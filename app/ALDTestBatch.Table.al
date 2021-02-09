table 55100 "ALD Test Batch"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Name; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[50])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
}