namespace Morcadium.BCAPIDemo.Integration;


enum 70000 StatusMORAPI
{
    Extensible = true;

    value(10; Pending)
    {
        Caption = 'Pending';
    }
    value(20; Complete)
    {
        Caption = 'Complete';
    }
    value(30; Error)
    {
        Caption = 'Error';
    }
    value(40; Superseded)
    {
        Caption = 'Superseded';
    }
    value(50; Canceled)
    {
        Caption = 'Canceled';
    }
}