unit uInterfacesHttp;

interface

uses
  System.JSON,
  REST.Client,
  REST.Authenticator.Basic,
  uTypeAuth;

type
  iAuth = interface
    ['{6C05C047-F25F-48D9-B329-E87934B75737}']
  end;

  iConfigure = interface
    ['{EB7389F4-A29C-44A5-ABC0-139712FCD6B0}']
  end;

  iToken = interface
    ['{52E98633-CA35-4405-9B06-F8150245C23A}']
  end;

  iTratamento = interface
    ['{FD285143-6C58-44DE-AEAC-A93C9EB0B43D}']
  end;

implementation

end.
