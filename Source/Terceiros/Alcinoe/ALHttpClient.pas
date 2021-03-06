{ *************************************************************
  www:          http://sourceforge.net/projects/alcinoe/
  svn:          svn checkout svn://svn.code.sf.net/p/alcinoe/code/ alcinoe-code
  Author(s):    St?phane Vander Clock (alcinoe@arkadia.com)
  Sponsor(s):   Arkadia SA (http://www.arkadia.com)

  product:      ALHttpClient Base Class
  Version:      4.00

  Description:  TALHttpClient is a ancestor of class like
  TALWinInetHttpClient or TALWinHttpClient

  Legal issues: Copyright (C) 1999-2013 by Arkadia Software Engineering

  This software is provided 'as-is', without any express
  or implied warranty.  In no event will the author be
  held liable for any  damages arising from the use of
  this software.

  Permission is granted to anyone to use this software
  for any purpose, including commercial applications,
  and to alter it and redistribute it freely, subject
  to the following restrictions:

  1. The origin of this software must not be
  misrepresented, you must not claim that you wrote
  the original software. If you use this software in
  a product, an acknowledgment in the product
  documentation would be appreciated but is not
  required.

  2. Altered source versions must be plainly marked as
  such, and must not be misrepresented as being the
  original software.

  3. This notice may not be removed or altered from any
  source distribution.

  4. You must register this software by sending a picture
  postcard to the author. Use a nice stamp and mention
  your name, street address, EMail address and any
  comment you like to say.

  Know bug :

  History :     28/11/2005: move public procedure to published
  in TALHttpClientProxyParams
  26/06/2012: Add xe2 support

  Link :        http://www.w3.org/TR/REC-html40/interact/forms.html#h-17.1
  http://www.ietf.org/rfc/rfc1867.txt
  http://www.ietf.org/rfc/rfc2388.txt
  http://www.w3.org/MarkUp/html-spec/html-spec_8.html
  http://www.cs.tut.fi/~jkorpela/forms/methods.html
  http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
  http://wp.netscape.com/newsref/std/cookie_spec.html

  * Please send all your feedback to alcinoe@arkadia.com
  * If you have downloaded this source from a website different from
  sourceforge.net, please get the last version on http://sourceforge.net/projects/alcinoe/
  * Please, help us to keep the development of these components free by
  promoting the sponsor on http://static.arkadia.com/html/alcinoe_like.html
  ************************************************************** }
unit ALHttpClient;

interface

{$IF CompilerVersion >= 25} { Delphi XE4 }
{$LEGACYIFEND ON} // http://docwiki.embarcadero.com/RADStudio/XE4/en/Legacy_IFEND_(Delphi)
{$IFEND}

uses {$IF CompilerVersion >= 28} {Delphi XE2}
  System.SysUtils,
  System.Classes,
  System.NetEncoding,
  Winapi.Wininet,
{$ELSE}
  SysUtils,
  Classes,
  Wininet,
{$IFEND}
  ALStringList,
  ALMultiPartParser;

type

  { -- onchange Event that specify the property index that is just changed -- }
  TALHTTPPropertyChangeEvent = procedure(sender: Tobject;
    Const PropertyIndex: Integer) of object;

  { --protocol version-- }
  TALHTTPProtocolVersion = (HTTPpv_1_0, HTTPpv_1_1);

  { --Request method-- }
  TALHTTPMethod = (HTTPmt_Get, HTTPmt_Post, HTTPmt_Head, HTTPmt_Trace,
    HTTPmt_Put, HTTPmt_Delete);

  { --Request header-- }
  TALHTTPRequestHeader = Class(Tobject)
  Private
    fAccept: AnsiString;
    fAcceptCharSet: AnsiString;
    fAcceptEncoding: AnsiString;
    fAcceptLanguage: AnsiString;
    fAllow: AnsiString;
    fAuthorization: AnsiString;
    fCacheControl: AnsiString;
    fConnection: AnsiString;
    fContentEncoding: AnsiString;
    fContentLanguage: AnsiString;
    fContentLength: AnsiString;
    fContentLocation: AnsiString;
    fContentMD5: AnsiString;
    fContentRange: AnsiString;
    fContentType: AnsiString;
    fDate: AnsiString;
    fExpect: AnsiString;
    fExpires: AnsiString;
    fFrom: AnsiString;
    fHost: AnsiString;
    fIfMatch: AnsiString;
    fIfModifiedSince: AnsiString;
    fIfNoneMatch: AnsiString;
    fIfRange: AnsiString;
    fIfUnmodifiedSince: AnsiString;
    fLastModified: AnsiString;
    fMaxForwards: AnsiString;
    fPragma: AnsiString;
    fProxyAuthorization: AnsiString;
    fRange: AnsiString;
    fReferer: AnsiString;
    fTE: AnsiString;
    fTrailer: AnsiString;
    fTransferEncoding: AnsiString;
    fUpgrade: AnsiString;
    fUserAgent: AnsiString;
    fVia: AnsiString;
    fWarning: AnsiString;
    FCustomHeaders: TALStrings;
    FCookies: TALStrings;
    FOnChange: TALHTTPPropertyChangeEvent;
    Procedure DoChange(PropertyIndex: Integer);
    procedure SetHeaderValueByPropertyIndex(const Index: Integer;
      const Value: AnsiString);
    Function GetRawHeaderText: AnsiString;
    procedure SetCookies(const Value: TALStrings);
    procedure SetRawHeaderText(const aRawHeaderText: AnsiString);
    procedure SetCustomHeaders(const Value: TALStrings);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    Property RawHeaderText: AnsiString read GetRawHeaderText
      write SetRawHeaderText;
    property Accept: AnsiString index 0 read fAccept
      write SetHeaderValueByPropertyIndex;
    { Accept: audio/*; q=0.2, audio/basic }
    property AcceptCharSet: AnsiString index 1 read fAcceptCharSet
      write SetHeaderValueByPropertyIndex;
    { Accept-Charset: iso-8859-5, unicode-1-1;q=0.8 }
    property AcceptEncoding: AnsiString index 2 read fAcceptEncoding
      write SetHeaderValueByPropertyIndex;
    { Accept-Encoding: gzip;q=1.0, identity; q=0.5, *;q=0 }
    property AcceptLanguage: AnsiString index 3 read fAcceptLanguage
      write SetHeaderValueByPropertyIndex;
    { Accept-Language: da, en-gb;q=0.8, en;q=0.7 }
    property Allow: AnsiString index 4 read fAllow
      write SetHeaderValueByPropertyIndex; { Allow: GET, HEAD, PUT }
    property Authorization: AnsiString index 5 read fAuthorization
      write SetHeaderValueByPropertyIndex;
    { Authorization: BASIC d2VibWFzdGVyOnpycW1hNHY= }
    property CacheControl: AnsiString index 6 read fCacheControl
      write SetHeaderValueByPropertyIndex; { Cache-Control: no-cache }
    property Connection: AnsiString index 7 read fConnection
      write SetHeaderValueByPropertyIndex; { Connection: close }
    property ContentEncoding: AnsiString index 8 read fContentEncoding
      write SetHeaderValueByPropertyIndex; { Content-Encoding: gzip }
    property ContentLanguage: AnsiString index 9 read fContentLanguage
      write SetHeaderValueByPropertyIndex; { Content-Language: mi, en }
    property ContentLength: AnsiString index 10 read fContentLength
      write SetHeaderValueByPropertyIndex; { Content-Length: 3495 }
    property ContentLocation: AnsiString index 11 read fContentLocation
      write SetHeaderValueByPropertyIndex;
    { Content-Location: http://localhost/page.asp }
    property ContentMD5: AnsiString index 12 read fContentMD5
      write SetHeaderValueByPropertyIndex; { Content-MD5: [md5-digest] }
    property ContentRange: AnsiString index 13 read fContentRange
      write SetHeaderValueByPropertyIndex;
    { Content-Range: bytes 2543-4532/7898 }
    property ContentType: AnsiString index 14 read fContentType
      write SetHeaderValueByPropertyIndex;
    { Content-Type: text/html; charset=ISO-8859-4 }
    property Date: AnsiString index 15 read fDate
      write SetHeaderValueByPropertyIndex;
    { Date: Tue, 15 Nov 1994 08:12:31 GMT }
    property Expect: AnsiString index 16 read fExpect
      write SetHeaderValueByPropertyIndex; { Expect: 100-continue }
    property Expires: AnsiString index 17 read fExpires
      write SetHeaderValueByPropertyIndex;
    { Expires: Thu, 01 Dec 1994 16:00:00 GMT }
    property From: AnsiString index 18 read fFrom
      write SetHeaderValueByPropertyIndex; { From: webmaster@w3.org }
    property Host: AnsiString index 19 read fHost
      write SetHeaderValueByPropertyIndex; { Host: www.w3.org }
    property IfMatch: AnsiString index 20 read fIfMatch
      write SetHeaderValueByPropertyIndex; { If-Match: entity_tag001 }
    property IfModifiedSince: AnsiString index 21 read fIfModifiedSince
      write SetHeaderValueByPropertyIndex;
    { If-Modified-Since: Sat, 29 Oct 1994 19:43:31 GMT }
    property IfNoneMatch: AnsiString index 22 read fIfNoneMatch
      write SetHeaderValueByPropertyIndex; { If-None-Match: entity_tag001 }
    property IfRange: AnsiString index 23 read fIfRange
      write SetHeaderValueByPropertyIndex; { If-Range: entity_tag001 }
    property IfUnmodifiedSince: AnsiString index 24 read fIfUnmodifiedSince
      write SetHeaderValueByPropertyIndex;
    { If-Unmodified-Since: Sat, 29 Oct 1994 19:43:31 GMT }
    property LastModified: AnsiString index 25 read fLastModified
      write SetHeaderValueByPropertyIndex;
    { Last-Modified: Tue, 15 Nov 1994 12:45:26 GMT }
    property MaxForwards: AnsiString index 26 read fMaxForwards
      write SetHeaderValueByPropertyIndex; { Max-Forwards: 3 }
    property Pragma: AnsiString index 27 read fPragma
      write SetHeaderValueByPropertyIndex; { Pragma: no-cache }
    property ProxyAuthorization: AnsiString index 28 read fProxyAuthorization
      write SetHeaderValueByPropertyIndex;
    { Proxy-Authorization: [credentials] }
    property Range: AnsiString index 29 read fRange
      write SetHeaderValueByPropertyIndex; { Range: bytes=100-599 }
    property Referer: AnsiString index 30 read fReferer
      write SetHeaderValueByPropertyIndex;
    { Referer: http://www.w3.org/hypertext/DataSources/Overview.html }
    property TE: AnsiString index 31 read fTE
      write SetHeaderValueByPropertyIndex; { TE: trailers, deflate;q=0.5 }
    property Trailer: AnsiString index 32 read fTrailer
      write SetHeaderValueByPropertyIndex; { Trailer: Date }
    property TransferEncoding: AnsiString index 33 read fTransferEncoding
      write SetHeaderValueByPropertyIndex; { Transfer-Encoding: chunked }
    property Upgrade: AnsiString index 34 read fUpgrade
      write SetHeaderValueByPropertyIndex;
    { Upgrade: HTTP/2.0, SHTTP/1.3, IRC/6.9, RTA/x11 }
    property UserAgent: AnsiString index 35 read fUserAgent
      write SetHeaderValueByPropertyIndex;
    { User-Agent: CERN-LineMode/2.15 libwww/2.17b3 }
    property Via: AnsiString index 36 read fVia
      write SetHeaderValueByPropertyIndex;
    { Via: 1.0 ricky, 1.1 mertz, 1.0 lucy }
    property Warning: AnsiString index 37 read fWarning
      write SetHeaderValueByPropertyIndex;
    { Warning: 112 Disconnected Operation }
    property CustomHeaders: TALStrings read FCustomHeaders
      write SetCustomHeaders;
    property Cookies: TALStrings read FCookies write SetCookies;
    property OnChange: TALHTTPPropertyChangeEvent read FOnChange
      write FOnChange;
  end;

  { --TALHTTPCookie-- }
  TALHTTPCookie = class(TCollectionItem)
  private
    FName: AnsiString;
    FValue: AnsiString;
    FPath: AnsiString;
    FDomain: AnsiString;
    fExpires: TDateTime;
    FSecure: Boolean;
  protected
    function GetHeaderValue: AnsiString;
    procedure SetHeaderValue(Const aValue: AnsiString);
  public
    constructor Create(Collection: TCollection); override;
    procedure AssignTo(Dest: TPersistent); override;
    property Name: AnsiString read FName write FName;
    property Value: AnsiString read FValue write FValue;
    property Domain: AnsiString read FDomain write FDomain;
    property Path: AnsiString read FPath write FPath;
    property Expires: TDateTime read fExpires write fExpires;
    property Secure: Boolean read FSecure write FSecure;
    property HeaderValue: AnsiString read GetHeaderValue write SetHeaderValue;
  end;

  { --TALCookieCollection-- }
  TALHTTPCookieCollection = class(TCollection)
  private
  protected
    function GetCookie(Index: Integer): TALHTTPCookie;
    procedure SetCookie(Index: Integer; Cookie: TALHTTPCookie);
  public
    function Add: TALHTTPCookie;
    property Items[Index: Integer]: TALHTTPCookie read GetCookie
      write SetCookie; default;
  end;

  { --Response header-- }
  TALHTTPResponseHeader = Class(Tobject)
  Private
    FAcceptRanges: AnsiString;
    FAge: AnsiString;
    fAllow: AnsiString;
    fCacheControl: AnsiString;
    fConnection: AnsiString;
    fContentEncoding: AnsiString;
    fContentLanguage: AnsiString;
    fContentLength: AnsiString;
    fContentLocation: AnsiString;
    fContentMD5: AnsiString;
    fContentRange: AnsiString;
    fContentType: AnsiString;
    fDate: AnsiString;
    FETag: AnsiString;
    fExpires: AnsiString;
    fLastModified: AnsiString;
    FLocation: AnsiString;
    fPragma: AnsiString;
    FProxyAuthenticate: AnsiString;
    FRetryAfter: AnsiString;
    FServer: AnsiString;
    fTrailer: AnsiString;
    fTransferEncoding: AnsiString;
    fUpgrade: AnsiString;
    FVary: AnsiString;
    fVia: AnsiString;
    fWarning: AnsiString;
    FWWWAuthenticate: AnsiString;
    FRawHeaderText: AnsiString;
    FCustomHeaders: TALStrings;
    FCookies: TALHTTPCookieCollection;
    FStatusCode: AnsiString;
    FHttpProtocolVersion: AnsiString;
    FReasonPhrase: AnsiString;
    procedure SetRawHeaderText(const aRawHeaderText: AnsiString);
    Function GetRawHeaderText: AnsiString;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    property AcceptRanges: AnsiString read FAcceptRanges;
    { Accept-Ranges: bytes }
    property Age: AnsiString read FAge; { Age: 2147483648(2^31) }
    property Allow: AnsiString read fAllow; { Allow: GET, HEAD, PUT }
    property CacheControl: AnsiString read fCacheControl;
    { Cache-Control: no-cache }
    property Connection: AnsiString read fConnection; { Connection: close }
    property ContentEncoding: AnsiString read fContentEncoding;
    { Content-Encoding: gzip }
    property ContentLanguage: AnsiString read fContentLanguage;
    { Content-Language: mi, en }
    property ContentLength: AnsiString read fContentLength;
    { Content-Length: 3495 }
    property ContentLocation: AnsiString read fContentLocation;
    { Content-Location: http://localhost/page.asp }
    property ContentMD5: AnsiString read fContentMD5;
    { Content-MD5: [md5-digest] }
    property ContentRange: AnsiString read fContentRange;
    { Content-Range: bytes 2543-4532/7898 }
    property ContentType: AnsiString read fContentType;
    { Content-Type: text/html; charset=ISO-8859-4 }
    property Date: AnsiString read fDate;
    { Date: Tue, 15 Nov 1994 08:12:31 GMT }
    property ETag: AnsiString read FETag; { ETag: W/"xyzzy" }
    property Expires: AnsiString read fExpires;
    { Expires: Thu, 01 Dec 1994 16:00:00 GMT }
    property LastModified: AnsiString read fLastModified;
    { Last-Modified: Tue, 15 Nov 1994 12:45:26 GMT }
    property Location: AnsiString read FLocation;
    { Location: http://www.w3.org/pub/WWW/People.html }
    property Pragma: AnsiString read fPragma; { Pragma: no-cache }
    property ProxyAuthenticate: AnsiString read FProxyAuthenticate;
    { Proxy-Authenticate: [challenge] }
    property RetryAfter: AnsiString read FRetryAfter;
    { Retry-After: Fri, 31 Dec 1999 23:59:59 GMT }
    property Server: AnsiString read FServer; { Server: CERN/3.0 libwww/2.17 }
    property Trailer: AnsiString read fTrailer; { Trailer: Date }
    property TransferEncoding: AnsiString read fTransferEncoding;
    { Transfer-Encoding: chunked }
    property Upgrade: AnsiString read fUpgrade;
    { Upgrade: HTTP/2.0, SHTTP/1.3, IRC/6.9, RTA/x11 }
    property Vary: AnsiString read FVary; { Vary: Date }
    property Via: AnsiString read fVia; { Via: 1.0 ricky, 1.1 mertz, 1.0 lucy }
    property Warning: AnsiString read fWarning;
    { Warning: 112 Disconnected Operation }
    property WWWAuthenticate: AnsiString read FWWWAuthenticate;
    { WWW-Authenticate: [challenge] }
    Property CustomHeaders: TALStrings read FCustomHeaders;
    Property Cookies: TALHTTPCookieCollection read FCookies;
    property StatusCode: AnsiString read FStatusCode;
    property HttpProtocolVersion: AnsiString read FHttpProtocolVersion;
    Property ReasonPhrase: AnsiString read FReasonPhrase;
    property RawHeaderText: AnsiString read GetRawHeaderText
      write SetRawHeaderText;
  end;

  { --------------------------------------- }
  EALHTTPClientException = class(Exception)
  private
    FStatusCode: Integer;
  public
    constructor Create(const Msg: AnsiString; SCode: Integer = 0);
    constructor CreateFmt(const Msg: AnsiString; const Args: array of const;
      SCode: Integer = 0);
    property StatusCode: Integer read FStatusCode write FStatusCode;
  end;

  { --------------------------------------- }
  TALHTTPClientProxyParams = Class(Tobject)
  Private
    FProxyBypass: AnsiString;
    FproxyServer: AnsiString;
    FProxyUserName: AnsiString;
    FProxyPassword: AnsiString;
    FproxyPort: Integer;
    FOnChange: TALHTTPPropertyChangeEvent;
    procedure SetProxyBypass(const Value: AnsiString);
    procedure SetProxyPassword(const Value: AnsiString);
    procedure SetProxyPort(const Value: Integer);
    procedure SetProxyServer(const Value: AnsiString);
    procedure SetProxyUserName(const Value: AnsiString);
    Procedure DoChange(PropertyIndex: Integer);
  public
    constructor Create; virtual;
    procedure Clear;
    Property ProxyBypass: AnsiString read FProxyBypass write SetProxyBypass;
    // index 0
    property ProxyServer: AnsiString read FproxyServer write SetProxyServer;
    // index 1
    property ProxyPort: Integer read FproxyPort write SetProxyPort default 0;
    // index 2
    property ProxyUserName: AnsiString read FProxyUserName
      write SetProxyUserName; // index 3
    property ProxyPassword: AnsiString read FProxyPassword
      write SetProxyPassword; // index 4
    property OnChange: TALHTTPPropertyChangeEvent read FOnChange
      write FOnChange;
  end;

  { -------------------------------------------------------------------------------------------------- }
  TAlHTTPClientRedirectEvent = procedure(sender: Tobject;
    const NewURL: AnsiString) of object;
  TALHTTPClientUploadProgressEvent = procedure(sender: Tobject; Sent: Integer;
    Total: Integer) of object;
  TALHTTPClientDownloadProgressEvent = procedure(sender: Tobject; Read: Integer;
    Total: Integer) of object;

  { ---------------------------- }
  TALHTTPClient = class(Tobject)
  private
    FProxyParams: TALHTTPClientProxyParams;
    FRequestHeader: TALHTTPRequestHeader;
    FProtocolVersion: TALHTTPProtocolVersion;
    FRequestMethod: TALHTTPMethod;
    FURL: AnsiString;
    FUserName: AnsiString;
    FPassword: AnsiString;
    FConnectTimeout: Integer;
    FSendTimeout: Integer;
    FReceiveTimeout: Integer;
    FOnUploadProgress: TALHTTPClientUploadProgressEvent;
    FOnDownloadProgress: TALHTTPClientDownloadProgressEvent;
    FOnRedirect: TAlHTTPClientRedirectEvent;
    FUploadBufferSize: Integer;
  protected
    procedure SetURL(const Value: AnsiString); virtual;
    procedure SetUsername(const NameValue: AnsiString); virtual;
    procedure SetPassword(const PasswordValue: AnsiString); virtual;
    procedure OnProxyParamsChange(sender: Tobject;
      Const PropertyIndex: Integer); virtual;
    procedure OnRequestHeaderChange(sender: Tobject;
      Const PropertyIndex: Integer); virtual;
    procedure SetUploadBufferSize(const Value: Integer); virtual;
    procedure SetOnRedirect(const Value: TAlHTTPClientRedirectEvent); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Execute(aRequestDataStream: TStream;
      aResponseContentStream: TStream;
      aResponseContentHeader: TALHTTPResponseHeader); virtual;
    Procedure Get(const aUrl: AnsiString; aResponseContentStream: TStream;
      aResponseContentHeader: TALHTTPResponseHeader); overload;
    Procedure Post(const aUrl: AnsiString; aResponseContentStream: TStream;
      aResponseContentHeader: TALHTTPResponseHeader); overload;
    Procedure Post(const aUrl: AnsiString; aPostDataStream: TStream;
      aResponseContentStream: TStream;
      aResponseContentHeader: TALHTTPResponseHeader); overload;
    Procedure PostUrlEncoded(const aUrl: AnsiString;
      aPostDataStrings: TALStrings; aResponseContentStream: TStream;
      aResponseContentHeader: TALHTTPResponseHeader;
      Const EncodeParams: Boolean = True); overload;
    Procedure PostMultipartFormData(const aUrl: AnsiString;
      aPostDataStrings: TALStrings;
      aPostDataFiles: TALMultiPartFormDataContents;
      aResponseContentStream: TStream;
      aResponseContentHeader: TALHTTPResponseHeader); overload;
    Procedure Head(const aUrl: AnsiString; aResponseContentStream: TStream;
      aResponseContentHeader: TALHTTPResponseHeader); overload;
    Procedure Trace(const aUrl: AnsiString; aResponseContentStream: TStream;
      aResponseContentHeader: TALHTTPResponseHeader); overload;
    Procedure Put(const aUrl: AnsiString; aPutDataStream: TStream;
      aResponseContentStream: TStream;
      aResponseContentHeader: TALHTTPResponseHeader); overload;
    procedure Delete(const aUrl: AnsiString; aResponseContentStream: TStream;
      aResponseContentHeader: TALHTTPResponseHeader); overload;
    Function Get(const aUrl: AnsiString): AnsiString; overload;
    Function Get(const aUrl: AnsiString; aParams: TALStrings;
      Const EncodeParams: Boolean = True): AnsiString; overload;
    Procedure Get(const aUrl: AnsiString; aParams: TALStrings;
      aResponseContentStream: TStream;
      aResponseContentHeader: TALHTTPResponseHeader;
      Const EncodeParams: Boolean = True); overload;
    Function Post(const aUrl: AnsiString): AnsiString; overload;
    Function Post(const aUrl: AnsiString; aPostDataStream: TStream)
      : AnsiString; overload;
    Function PostUrlEncoded(const aUrl: AnsiString;
      aPostDataStrings: TALStrings; Const EncodeParams: Boolean = True)
      : AnsiString; overload;
    Function PostMultipartFormData(const aUrl: AnsiString;
      aPostDataStrings: TALStrings;
      aPostDataFiles: TALMultiPartFormDataContents): AnsiString; overload;
    Function Head(const aUrl: AnsiString): AnsiString; overload;
    Function Trace(const aUrl: AnsiString): AnsiString; overload;
    function Put(const aUrl: AnsiString; aPutDataStream: TStream)
      : AnsiString; overload;
    function Delete(const aUrl: AnsiString): AnsiString; overload;
    property URL: AnsiString read FURL write SetURL;
    property ConnectTimeout: Integer read FConnectTimeout write FConnectTimeout
      default 0;
    property SendTimeout: Integer read FSendTimeout write FSendTimeout
      default 0;
    property ReceiveTimeout: Integer read FReceiveTimeout write FReceiveTimeout
      default 0;
    property UploadBufferSize: Integer read FUploadBufferSize
      write SetUploadBufferSize default $8000;
    property ProxyParams: TALHTTPClientProxyParams read FProxyParams;
    property RequestHeader: TALHTTPRequestHeader read FRequestHeader;
    Property ProtocolVersion: TALHTTPProtocolVersion read FProtocolVersion
      write FProtocolVersion default HTTPpv_1_1;
    Property RequestMethod: TALHTTPMethod read FRequestMethod
      write FRequestMethod default HTTPmt_Get;
    property UserName: AnsiString read FUserName write SetUsername;
    property Password: AnsiString read FPassword write SetPassword;
    property OnUploadProgress: TALHTTPClientUploadProgressEvent
      read FOnUploadProgress write FOnUploadProgress;
    property OnDownloadProgress: TALHTTPClientDownloadProgressEvent
      read FOnDownloadProgress write FOnDownloadProgress;
    property OnRedirect: TAlHTTPClientRedirectEvent read FOnRedirect
      write SetOnRedirect;
  end;

  { Http Function }
function ALHTTPDecode(const AStr: AnsiString): AnsiString;
procedure ALHTTPEncodeParamNameValues(ParamValues: TALStrings);
procedure ALExtractHTTPFields(Separators, WhiteSpace, Quotes: TSysCharSet;
  Content: PAnsiChar; Strings: TALStrings; StripQuotes: Boolean = False);
procedure ALExtractHeaderFields(Separators, WhiteSpace, Quotes: TSysCharSet;
  Content: PAnsiChar; Strings: TALStrings; Decode: Boolean;
  StripQuotes: Boolean = False);
procedure ALExtractHeaderFieldsWithQuoteEscaped(Separators, WhiteSpace,
  Quotes: TSysCharSet; Content: PAnsiChar; Strings: TALStrings; Decode: Boolean;
  StripQuotes: Boolean = False);
Function AlRemoveShemeFromUrl(aUrl: AnsiString): AnsiString;
Function AlExtractShemeFromUrl(aUrl: AnsiString): TInternetScheme;
Function AlExtractHostNameFromUrl(aUrl: AnsiString): AnsiString;
Function AlExtractDomainNameFromUrl(aUrl: AnsiString): AnsiString;
Function AlExtractUrlPathFromUrl(aUrl: AnsiString): AnsiString;
Function AlInternetCrackUrl(aUrl: AnsiString;
  Var SchemeName, HostName, UserName, Password, UrlPath, ExtraInfo: AnsiString;
  var PortNumber: Integer): Boolean; overload;
Function AlInternetCrackUrl(aUrl: AnsiString;
  Var SchemeName, HostName, UserName, Password, UrlPath, Anchor: AnsiString;
  // not the anchor is never send to the server ! it's only used on client side
  Query: TALStrings; var PortNumber: Integer): Boolean; overload;
Function AlInternetCrackUrl(var URL: AnsiString; // if true return UrlPath
  var Anchor: AnsiString; Query: TALStrings): Boolean; overload;
Function AlRemoveAnchorFromUrl(aUrl: AnsiString; Var aAnchor: AnsiString)
  : AnsiString; overload;
Function AlRemoveAnchorFromUrl(aUrl: AnsiString): AnsiString; overload;
function AlCombineUrl(RelativeUrl, BaseUrl: AnsiString): AnsiString; overload;
Function AlCombineUrl(RelativeUrl, BaseUrl, Anchor: AnsiString;
  Query: TALStrings): AnsiString; overload;

const
  CAlRfc822DayOfWeekNames: array [1 .. 7] of AnsiString = ('Sun', 'Mon', 'Tue',
    'Wed', 'Thu', 'Fri', 'Sat');

  CALRfc822MonthOfTheYearNames: array [1 .. 12] of AnsiString = ('Jan', 'Feb',
    'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');

function ALGmtDateTimeToRfc822Str(const aValue: TDateTime): AnsiString;
function ALDateTimeToRfc822Str(const aValue: TDateTime): AnsiString;
Function ALTryRfc822StrToGMTDateTime(const S: AnsiString;
  out Value: TDateTime): Boolean;
function ALRfc822StrToGMTDateTime(const S: AnsiString): TDateTime;

Function ALTryIPV4StrToNumeric(aIPv4Str: AnsiString;
  var aIPv4Num: Cardinal): Boolean;
Function ALIPV4StrToNumeric(aIPv4: AnsiString): Cardinal;
Function ALNumericToIPv4Str(aIPv4: Cardinal): AnsiString;

type
  TALIPv6Binary = array [1 .. 16] of ansiChar;

Function ALZeroIpV6: TALIPv6Binary;
Function ALTryIPV6StrToBinary(aIPv6Str: AnsiString;
  var aIPv6Bin: TALIPv6Binary): Boolean;
Function ALIPV6StrTobinary(aIPv6: AnsiString): TALIPv6Binary;
Function ALBinaryToIPv6Str(aIPv6: TALIPv6Binary): AnsiString;
Function ALBinaryStrToIPv6Binary(aIPV6BinaryStr: AnsiString): TALIPv6Binary;

Const
  cALHTTPCLient_MsgInvalidURL =
    'Invalid url ''%s'' - only supports ''http'' and ''https'' schemes';
  cALHTTPCLient_MsgInvalidHTTPRequest = 'Invalid HTTP Request: Length is 0';
  cALHTTPCLient_MsgEmptyURL = 'Empty URL';

implementation

uses {$IF CompilerVersion >= 23} {Delphi XE2}
  Winapi.Windows,
  Web.HttpApp,
  System.DateUtils,
  System.SysConst,
{$ELSE}
  Windows,
  HttpApp,
  DateUtils,
  SysConst,
{$IFEND}
  AlMisc,
  ALString;

{ *********************************************************************************** }
function AlStringFetch(var AInput: AnsiString; const ADelim: AnsiString)
  : AnsiString;
var
  LPos: Integer;
begin
  LPos := AlPos(ADelim, AInput);
  if LPos <= 0 then
  begin
    Result := AInput;
    AInput := '';
  end
  else
  begin
    Result := AlCopyStr(AInput, 1, LPos - 1);
    AInput := AlCopyStr(AInput, LPos + Length(ADelim), MaxInt);
  end;
end;

{ ******************************************************** }
constructor TALHTTPCookie.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FName := '';
  FValue := '';
  FPath := '';
  FDomain := '';
  fExpires := -1;
  FSecure := False;
end;

{ ************************************************** }
procedure TALHTTPCookie.AssignTo(Dest: TPersistent);
begin
  if Dest is TALHTTPCookie then
    with TALHTTPCookie(Dest) do
    begin
      Name := Self.FName;
      Value := Self.FValue;
      Domain := Self.FDomain;
      Path := Self.FPath;
      Expires := Self.fExpires;
      Secure := Self.FSecure;
    end
  else
    inherited AssignTo(Dest);
end;

{ ************************************************ }
function TALHTTPCookie.GetHeaderValue: AnsiString;
begin
  {$IF CompilerVersion >= 28}
  Result := ALFormat('%s=%s; ', [TNetEncoding.URL.Encode(String(FName)), TNetEncoding.URL.Encode(String(FValue))]);
  {$ELSE}
  Result := ALFormat('%s=%s; ', [HTTPEncode(FName), HTTPEncode(FValue)]);
  {$IFEND}
  if Domain <> '' then
    Result := Result + ALFormat('domain=%s; ', [Domain]);
  if Path <> '' then
    Result := Result + ALFormat('path=%s; ', [Path]);
  if Expires > -1 then
  begin
    Result := Result + ALFormat
      (ALFormatDateTime('"expires=%s, "dd"-%s-"yyyy" "hh":"nn":"ss" GMT; "',
      Expires, ALDefaultFormatSettings),
      [CAlRfc822DayOfWeekNames[DayOfWeek(Expires)],
      CALRfc822MonthOfTheYearNames[MonthOf(Expires)]]);
  end;
  if Secure then
    Result := Result + 'secure';
  if AlCopyStr(Result, Length(Result) - 1, MaxInt) = '; ' then
    SetLength(Result, Length(Result) - 2);
end;

{ ***************** }
// exemple of value:
// LSID=DQAAAK?Eaem_vYg; Domain=docs.foo.com; Path=/accounts; Expires=Wed, 13-Jan-2021 22:23:01 GMT; Secure; HttpOnly
// HSID=AYQEVn?.DKrdst; Domain=.foo.com; Path=/; Expires=Wed, 13-Jan-2021 22:23:01 GMT; HttpOnly
// SSID=Ap4P?.GTEq; Domain=.foo.com; Path=/; Expires=Wed, 13-Jan-2021 22:23:01 GMT; Secure; HttpOnly
procedure TALHTTPCookie.SetHeaderValue(Const aValue: AnsiString);
Var
  aCookieProp: TALStringList;
  aCookieStr: AnsiString;
begin

  FName := '';
  FValue := '';
  FPath := '';
  FDomain := '';
  fExpires := -1;
  FSecure := False;

  aCookieProp := TALStringList.Create;
  try

    aCookieStr := ALTrim(aValue);
    while aCookieStr <> '' do
      aCookieProp.Add(ALTrim(AlStringFetch(aCookieStr, ';')));
    if aCookieProp.Count = 0 then
      exit;

    // Exemple of aCookieProp content :
    // LSID=DQAAAK?Eaem_vYg
    // Domain=docs.foo.com
    // Path=/accounts
    // Expires=Wed, 13-Jan-2021 22:23:01 GMT
    // Secure
    // HttpOnly

    FName := aCookieProp.Names[0];
    FValue := aCookieProp.ValueFromIndex[0];
    FPath := aCookieProp.values['PATH'];
    if FPath = '' then
      FPath := '/';
    if not ALTryRfc822StrToGMTDateTime(aCookieProp.values['EXPIRES'], fExpires)
    then
      fExpires := -1;
    FDomain := aCookieProp.values['DOMAIN'];
    FSecure := aCookieProp.IndexOf('SECURE') <> -1;

  finally
    aCookieProp.free;
  end;

end;

{ ************************************************** }
function TALHTTPCookieCollection.Add: TALHTTPCookie;
begin
  Result := TALHTTPCookie(inherited Add);
end;

{ ************************************************************************ }
function TALHTTPCookieCollection.GetCookie(Index: Integer): TALHTTPCookie;
begin
  Result := TALHTTPCookie(inherited Items[Index]);
end;

{ ********************************************************************************* }
procedure TALHTTPCookieCollection.SetCookie(Index: Integer;
  Cookie: TALHTTPCookie);
begin
  Items[Index].Assign(Cookie);
end;

{ *************************************** }
constructor TALHTTPResponseHeader.Create;
begin
  inherited;
  FCustomHeaders := TALStringList.Create;
  FCustomHeaders.NameValueSeparator := ':';
  FCookies := TALHTTPCookieCollection.Create(TALHTTPCookie);
  Clear;
end;

{ *************************************** }
destructor TALHTTPResponseHeader.Destroy;
begin
  FCustomHeaders.free;
  FCookies.free;
  inherited;
end;

{ ************************************ }
procedure TALHTTPResponseHeader.Clear;
begin
  FAcceptRanges := '';
  FAge := '';
  fAllow := '';
  fCacheControl := '';
  fConnection := '';
  fContentEncoding := '';
  fContentLanguage := '';
  fContentLength := '';
  fContentLocation := '';
  fContentMD5 := '';
  fContentRange := '';
  fContentType := '';
  fDate := '';
  FETag := '';
  fExpires := '';
  fLastModified := '';
  FLocation := '';
  fPragma := '';
  FProxyAuthenticate := '';
  FRetryAfter := '';
  FServer := '';
  fTrailer := '';
  fTransferEncoding := '';
  fUpgrade := '';
  FVary := '';
  fVia := '';
  fWarning := '';
  FWWWAuthenticate := '';
  FRawHeaderText := '';
  FCustomHeaders.Clear;
  FCookies.Clear;
  FStatusCode := '';
  FHttpProtocolVersion := '';
  FReasonPhrase := '';
end;

{ ********************************************************** }
function TALHTTPResponseHeader.GetRawHeaderText: AnsiString;
begin
  Result := FRawHeaderText;
end;

{ ********************************************************************************* }
procedure TALHTTPResponseHeader.SetRawHeaderText(Const aRawHeaderText
  : AnsiString);
Var
  aRawHeaderLst: TALStringList;
  j: Integer;
  AStatusLine: AnsiString;

  { --------------------------------------------- }
  Function AlG001(aName: AnsiString): AnsiString;
  Var
    i: Integer;
  Begin
    i := aRawHeaderLst.IndexOfName(aName);
    If i >= 0 then
    Begin
      Result := ALTrim(aRawHeaderLst.ValueFromIndex[i]);
      aRawHeaderLst.Delete(i);
    end
    else
      Result := '';
  end;

begin
  aRawHeaderLst := TALStringList.Create;
  try
    aRawHeaderLst.NameValueSeparator := ':';
    aRawHeaderLst.Text := aRawHeaderText;

    FAcceptRanges := AlG001('Accept-Ranges');
    FAge := AlG001('Age');
    fAllow := AlG001('Allow');
    fCacheControl := AlG001('Cache-Control');
    fConnection := AlG001('Connection');
    fContentEncoding := AlG001('Content-Encoding');
    fContentLanguage := AlG001('Content-Language');
    fContentLength := AlG001('Content-Length');
    fContentLocation := AlG001('Content-Location');
    fContentMD5 := AlG001('Content-MD5');
    fContentRange := AlG001('Content-Range');
    fContentType := AlG001('Content-Type');
    fDate := AlG001('Date');
    FETag := AlG001('ETag');
    fExpires := AlG001('Expires');
    fLastModified := AlG001('Last-Modified');
    FLocation := AlG001('Location');
    fPragma := AlG001('Pragma');
    FProxyAuthenticate := AlG001('Proxy-Authenticate');
    FRetryAfter := AlG001('Retry-After');
    FServer := AlG001('Server');
    fTrailer := AlG001('Trailer');
    fTransferEncoding := AlG001('Transfer-Encoding');
    fUpgrade := AlG001('Upgrade');
    FVary := AlG001('Vary');
    fVia := AlG001('Via');
    fWarning := AlG001('Warning');
    FWWWAuthenticate := AlG001('WWW-Authenticate');

    FCookies.Clear;
    j := aRawHeaderLst.IndexOfName('Set-Cookie');
    While j >= 0 do
    begin
      If ALTrim(aRawHeaderLst.ValueFromIndex[j]) <> '' then
        Cookies.Add.HeaderValue := ALTrim(aRawHeaderLst.ValueFromIndex[j]);
      aRawHeaderLst.Delete(j);
      j := aRawHeaderLst.IndexOfName('Set-Cookie');
    end;

    If aRawHeaderLst.Count > 0 then
    begin
      AStatusLine := aRawHeaderLst[0];
      // HTTP/1.1 200 OK | 200 OK | status: 200 OK
      FHttpProtocolVersion := ALTrim(AlStringFetch(AStatusLine, ' '));
      If AlIsInteger(FHttpProtocolVersion) then
      begin
        FStatusCode := FHttpProtocolVersion;
        FHttpProtocolVersion := '';
      end
      else
        FStatusCode := ALTrim(AlStringFetch(AStatusLine, ' '));
      FReasonPhrase := ALTrim(AStatusLine);

      If not AlIsInteger(FStatusCode) then
      begin
        FHttpProtocolVersion := '';
        AStatusLine := AlG001('Status');
        FStatusCode := ALTrim(AlStringFetch(AStatusLine, ' '));
        FReasonPhrase := ALTrim(AlStringFetch(AStatusLine, ' '));
      end
      else
        aRawHeaderLst.Delete(0);
    end
    else
    begin
      FStatusCode := '';
      FHttpProtocolVersion := '';
      FReasonPhrase := '';
    end;

    FCustomHeaders.Clear;
    For j := 0 to aRawHeaderLst.Count - 1 do
      If ALTrim(aRawHeaderLst[j]) <> '' then
        FCustomHeaders.Add(aRawHeaderLst[j]);

    FRawHeaderText := aRawHeaderText;
  finally
    aRawHeaderLst.free;
  end;
end;

{ ************************************** }
constructor TALHTTPRequestHeader.Create;
Begin
  inherited;
  FCustomHeaders := TALStringList.Create;
  FCustomHeaders.NameValueSeparator := ':';
  FCookies := TALStringList.Create;
  FOnChange := nil;
  Clear;
  fAccept := 'text/html, */*';
end;

{ ************************************** }
destructor TALHTTPRequestHeader.Destroy;
begin
  FCustomHeaders.free;
  FCookies.free;
  inherited;
end;

{ *********************************** }
procedure TALHTTPRequestHeader.Clear;
begin
  fAccept := '';
  fAcceptCharSet := '';
  fAcceptEncoding := '';
  fAcceptLanguage := '';
  fAllow := '';
  fAuthorization := '';
  fCacheControl := '';
  fConnection := '';
  fContentEncoding := '';
  fContentLanguage := '';
  fContentLength := '';
  fContentLocation := '';
  fContentMD5 := '';
  fContentRange := '';
  fContentType := '';
  fDate := '';
  fExpect := '';
  fExpires := '';
  fFrom := '';
  fHost := '';
  fIfMatch := '';
  fIfModifiedSince := '';
  fIfNoneMatch := '';
  fIfRange := '';
  fIfUnmodifiedSince := '';
  fLastModified := '';
  fMaxForwards := '';
  fPragma := '';
  fProxyAuthorization := '';
  fRange := '';
  fReferer := '';
  fTE := '';
  fTrailer := '';
  fTransferEncoding := '';
  fUpgrade := '';
  fUserAgent := '';
  fVia := '';
  fWarning := '';
  FCustomHeaders.Clear;
  FCookies.Clear;
  DoChange(-1);
end;

{ ************************************************************** }
procedure TALHTTPRequestHeader.DoChange(PropertyIndex: Integer);
begin
  if assigned(FOnChange) then
    FOnChange(Self, PropertyIndex);
end;

{ ********************************************************************************************************** }
procedure TALHTTPRequestHeader.SetHeaderValueByPropertyIndex
  (const Index: Integer; const Value: AnsiString);

{ ------------------------------------------ }
  procedure AlG001(Var AProperty: AnsiString);
  Begin
    If AProperty <> Value then
    begin
      AProperty := Value;
      DoChange(Index);
    end;
  end;

begin
  Case index of
    0:
      AlG001(fAccept);
    1:
      AlG001(fAcceptCharSet);
    2:
      AlG001(fAcceptEncoding);
    3:
      AlG001(fAcceptLanguage);
    4:
      AlG001(fAllow);
    5:
      AlG001(fAuthorization);
    6:
      AlG001(fCacheControl);
    7:
      AlG001(fConnection);
    8:
      AlG001(fContentEncoding);
    9:
      AlG001(fContentLanguage);
    10:
      AlG001(fContentLength);
    11:
      AlG001(fContentLocation);
    12:
      AlG001(fContentMD5);
    13:
      AlG001(fContentRange);
    14:
      AlG001(fContentType);
    15:
      AlG001(fDate);
    16:
      AlG001(fExpect);
    17:
      AlG001(fExpires);
    18:
      AlG001(fFrom);
    19:
      AlG001(fHost);
    20:
      AlG001(fIfMatch);
    21:
      AlG001(fIfModifiedSince);
    22:
      AlG001(fIfNoneMatch);
    23:
      AlG001(fIfRange);
    24:
      AlG001(fIfUnmodifiedSince);
    25:
      AlG001(fLastModified);
    26:
      AlG001(fMaxForwards);
    27:
      AlG001(fPragma);
    28:
      AlG001(fProxyAuthorization);
    29:
      AlG001(fRange);
    30:
      AlG001(fReferer);
    31:
      AlG001(fTE);
    32:
      AlG001(fTrailer);
    33:
      AlG001(fTransferEncoding);
    34:
      AlG001(fUpgrade);
    35:
      AlG001(fUserAgent);
    36:
      AlG001(fVia);
    37:
      AlG001(fWarning);
  end;
end;

{ ********************************************************* }
Function TALHTTPRequestHeader.GetRawHeaderText: AnsiString;
Var
  i: Integer;
begin
  Result := '';
  If ALTrim(fAccept) <> '' then
    Result := Result + 'Accept: ' + ALTrim(fAccept) + #13#10;
  If ALTrim(fAcceptCharSet) <> '' then
    Result := Result + 'Accept-Charset: ' + ALTrim(fAcceptCharSet) + #13#10;
  If ALTrim(fAcceptEncoding) <> '' then
    Result := Result + 'Accept-Encoding: ' + ALTrim(fAcceptEncoding) + #13#10;
  If ALTrim(fAcceptLanguage) <> '' then
    Result := Result + 'Accept-Language: ' + ALTrim(fAcceptLanguage) + #13#10;
  If ALTrim(fAllow) <> '' then
    Result := Result + 'Allow: ' + ALTrim(fAllow) + #13#10;
  If ALTrim(fAuthorization) <> '' then
    Result := Result + 'Authorization: ' + ALTrim(fAuthorization) + #13#10;
  If ALTrim(fCacheControl) <> '' then
    Result := Result + 'Cache-Control: ' + ALTrim(fCacheControl) + #13#10;
  If ALTrim(fConnection) <> '' then
    Result := Result + 'Connection: ' + ALTrim(fConnection) + #13#10;
  If ALTrim(fContentEncoding) <> '' then
    Result := Result + 'Content-Encoding: ' + ALTrim(fContentEncoding) + #13#10;
  If ALTrim(fContentLanguage) <> '' then
    Result := Result + 'Content-Language: ' + ALTrim(fContentLanguage) + #13#10;
  If ALTrim(fContentLength) <> '' then
    Result := Result + 'Content-Length: ' + ALTrim(fContentLength) + #13#10;
  If ALTrim(fContentLocation) <> '' then
    Result := Result + 'Content-Location: ' + ALTrim(fContentLocation) + #13#10;
  If ALTrim(fContentMD5) <> '' then
    Result := Result + 'Content-MD5: ' + ALTrim(fContentMD5) + #13#10;
  If ALTrim(fContentRange) <> '' then
    Result := Result + 'Content-Range: ' + ALTrim(fContentRange) + #13#10;
  If ALTrim(fContentType) <> '' then
    Result := Result + 'Content-Type: ' + ALTrim(fContentType) + #13#10;
  If ALTrim(fDate) <> '' then
    Result := Result + 'Date: ' + ALTrim(fDate) + #13#10;
  If ALTrim(fExpect) <> '' then
    Result := Result + 'Expect: ' + ALTrim(fExpect) + #13#10;
  If ALTrim(fExpires) <> '' then
    Result := Result + 'Expires: ' + ALTrim(fExpires) + #13#10;
  If ALTrim(fFrom) <> '' then
    Result := Result + 'From: ' + ALTrim(fFrom) + #13#10;
  If ALTrim(fHost) <> '' then
    Result := Result + 'Host: ' + ALTrim(fHost) + #13#10;
  If ALTrim(fIfMatch) <> '' then
    Result := Result + 'If-Match: ' + ALTrim(fIfMatch) + #13#10;
  If ALTrim(fIfModifiedSince) <> '' then
    Result := Result + 'If-Modified-Since: ' + ALTrim(fIfModifiedSince)
      + #13#10;
  If ALTrim(fIfNoneMatch) <> '' then
    Result := Result + 'If-None-Match: ' + ALTrim(fIfNoneMatch) + #13#10;
  If ALTrim(fIfRange) <> '' then
    Result := Result + 'If-Range: ' + ALTrim(fIfRange) + #13#10;
  If ALTrim(fIfUnmodifiedSince) <> '' then
    Result := Result + 'If-Unmodified-Since: ' +
      ALTrim(fIfUnmodifiedSince) + #13#10;
  If ALTrim(fLastModified) <> '' then
    Result := Result + 'Last-Modified: ' + ALTrim(fLastModified) + #13#10;
  If ALTrim(fMaxForwards) <> '' then
    Result := Result + 'Max-Forwards: ' + ALTrim(fMaxForwards) + #13#10;
  If ALTrim(fPragma) <> '' then
    Result := Result + 'Pragma: ' + ALTrim(fPragma) + #13#10;
  If ALTrim(fProxyAuthorization) <> '' then
    Result := Result + 'Proxy-Authorization: ' +
      ALTrim(fProxyAuthorization) + #13#10;
  If ALTrim(fRange) <> '' then
    Result := Result + 'Range: ' + ALTrim(fRange) + #13#10;
  If ALTrim(fReferer) <> '' then
    Result := Result + 'Referer: ' + ALTrim(fReferer) + #13#10;
  If ALTrim(fTE) <> '' then
    Result := Result + 'TE: ' + ALTrim(fTE) + #13#10;
  If ALTrim(fTrailer) <> '' then
    Result := Result + 'Trailer: ' + ALTrim(fTrailer) + #13#10;
  If ALTrim(fTransferEncoding) <> '' then
    Result := Result + 'Transfer-Encoding: ' +
      ALTrim(fTransferEncoding) + #13#10;
  If ALTrim(fUpgrade) <> '' then
    Result := Result + 'Upgrade: ' + ALTrim(fUpgrade) + #13#10;
  If ALTrim(fUserAgent) <> '' then
    Result := Result + 'User-Agent: ' + ALTrim(fUserAgent) + #13#10;
  If ALTrim(fVia) <> '' then
    Result := Result + 'Via: ' + ALTrim(fVia) + #13#10;
  If ALTrim(fWarning) <> '' then
    Result := Result + 'Warning: ' + ALTrim(fWarning) + #13#10;
  For i := 0 to FCustomHeaders.Count - 1 do
    if (ALTrim(FCustomHeaders.Names[i]) <> '') and
      (ALTrim(FCustomHeaders.ValueFromIndex[i]) <> '') then
      Result := Result + FCustomHeaders.Names[i] + ': ' +
        ALTrim(FCustomHeaders.ValueFromIndex[i]) + #13#10;
  If FCookies.Count > 0 then
    Result := Result + 'Cookie: ' + AlStringReplace(ALTrim(FCookies.Text),
      #13#10, '; ', [rfReplaceAll]) + #13#10;
end;

{ ******************************************************************************** }
procedure TALHTTPRequestHeader.SetRawHeaderText(const aRawHeaderText
  : AnsiString);
Var
  aRawHeaderLst: TALStringList;
  j: Integer;

  { --------------------------------------------- }
  Function AlG001(aName: AnsiString): AnsiString;
  Var
    i: Integer;
  Begin
    i := aRawHeaderLst.IndexOfName(aName);
    If i >= 0 then
    Begin
      Result := ALTrim(aRawHeaderLst.ValueFromIndex[i]);
      aRawHeaderLst.Delete(i);
    end
    else
      Result := '';
  end;

begin
  aRawHeaderLst := TALStringList.Create;
  try
    aRawHeaderLst.NameValueSeparator := ':';
    aRawHeaderLst.Text := aRawHeaderText;

    fAccept := AlG001('Accept');
    fAcceptCharSet := AlG001('Accept-Charset');
    fAcceptEncoding := AlG001('Accept-Encoding');
    fAcceptLanguage := AlG001('Accept-Language');
    fAllow := AlG001('Allow');
    fAuthorization := AlG001('Authorization');
    fCacheControl := AlG001('Cache-Control');
    fConnection := AlG001('Connection');
    fContentEncoding := AlG001('Content-Encoding');
    fContentLanguage := AlG001('Content-Language');
    fContentLength := AlG001('Content-Length');
    fContentLocation := AlG001('Content-Location');
    fContentMD5 := AlG001('Content-MD5');
    fContentRange := AlG001('Content-Range');
    fContentType := AlG001('Content-Type');
    fDate := AlG001('Date');
    fExpect := AlG001('Expect');
    fExpires := AlG001('Expires');
    fFrom := AlG001('From');
    fHost := AlG001('Host');
    fIfMatch := AlG001('If-Match');
    fIfModifiedSince := AlG001('If-Modified-Since');
    fIfNoneMatch := AlG001('If-None-Match');
    fIfRange := AlG001('If-Range');
    fIfUnmodifiedSince := AlG001('If-Unmodified-Since');
    fLastModified := AlG001('Last-Modified');
    fMaxForwards := AlG001('Max-Forwards');
    fPragma := AlG001('Pragma');
    fProxyAuthorization := AlG001('Proxy-Authorization');
    fRange := AlG001('Range');
    fReferer := AlG001('Referer');
    fTE := AlG001('TE');
    fTrailer := AlG001('Trailer');
    fTransferEncoding := AlG001('Transfer-Encoding');
    fUpgrade := AlG001('Upgrade');
    fUserAgent := AlG001('User-Agent');
    fVia := AlG001('Via');
    fWarning := AlG001('Warning');

    FCookies.Clear;
    j := aRawHeaderLst.IndexOfName('Cookie');
    If j >= 0 then
    begin
      ALExtractHTTPFields([';'], [' '], [],
        PAnsiChar(aRawHeaderLst.ValueFromIndex[j]), Cookies, True);
      aRawHeaderLst.Delete(j);
    end;

    FCustomHeaders.Clear;
    For j := 0 to aRawHeaderLst.Count - 1 do
      If ALTrim(aRawHeaderLst[j]) <> '' then
        FCustomHeaders.Add(aRawHeaderLst[j]);

    DoChange(-1);
  finally
    aRawHeaderLst.free;
  end;
end;

{ ***************************************************************** }
procedure TALHTTPRequestHeader.SetCookies(const Value: TALStrings);
begin
  FCookies.Assign(Value);
end;

{ *********************************************************************** }
procedure TALHTTPRequestHeader.SetCustomHeaders(const Value: TALStrings);
begin
  FCustomHeaders.Assign(Value);
end;

{ ************************************************************ }
// the difference between this function and the delphi function
// HttpApp.HttpDecode is that this function will not raise any
// error (EConvertError) when the url will contain % that
// are not encoded
function ALHTTPDecode(const AStr: AnsiString): AnsiString;
var
  Sp, Rp, Cp, Tp: PAnsiChar;
  int: Integer;
  S: AnsiString;
begin
  SetLength(Result, Length(AStr));
  Sp := PAnsiChar(AStr);
  Rp := PAnsiChar(Result);
  while Sp^ <> #0 do
  begin
    case Sp^ of
      '+':
        Rp^ := ' ';
      '%':
        begin
          Tp := Sp;
          Inc(Sp);

          // escaped % (%%)
          if Sp^ = '%' then
            Rp^ := '%'

            // %<hex> encoded character
          else
          begin
            Cp := Sp;
            Inc(Sp);
            if (Cp^ <> #0) and (Sp^ <> #0) then
            begin
              S := ansiChar('$') + ansiChar(Cp^) + ansiChar(Sp^);
              if ALTryStrToInt(S, int) then
                Rp^ := ansiChar(int)
              else
              begin
                Rp^ := '%';
                Sp := Tp;
              end;
            end
            else
            begin
              Rp^ := '%';
              Sp := Tp;
            end;
          end;
        end;
    else
      Rp^ := Sp^;
    end;
    Inc(Rp);
    Inc(Sp);
  end;
  SetLength(Result, Rp - PAnsiChar(Result));
end;

{ ************************************************************* }
procedure ALHTTPEncodeParamNameValues(ParamValues: TALStrings);
var
  i: Integer;
  LPos: Integer;
  LStr: AnsiString;
begin
  for i := 0 to ParamValues.Count - 1 do
  begin
    LStr := ParamValues[i];
    LPos := AlPos(ParamValues.NameValueSeparator, LStr);
    if LPos > 0 then
      {$IF CompilerVersion >= 28}
      ParamValues[i] := AnsiString(TNetEncoding.URL.Encode(String(AlCopyStr(LStr, 1, LPos - 1))) + '=' +
        TNetEncoding.URL.Encode(String(AlCopyStr(LStr, LPos + 1, MaxInt))));
      {$ELSE}
      ParamValues[i] := HTTPEncode(AlCopyStr(LStr, 1, LPos - 1)) + '=' +
        HTTPEncode(AlCopyStr(LStr, LPos + 1, MaxInt));
      {$IFEND}
  end;
end;

{ ******************************************************** }
{ Parses a multi-valued string into its constituent fields.
  ExtractHTTPFields is a general utility to parse multi-valued HTTP header strings into separate substrings.
  *Separators is a set of characters that are used to separate individual values within the multi-valued string.
  *WhiteSpace is a set of characters that are to be ignored when parsing the string.
  *Content is the multi-valued string to be parsed.
  *Strings is the TStrings object that receives the individual values that are parsed from Content.
  *StripQuotes determines whether the surrounding quotes are removed from the resulting items. When StripQuotes is true, surrounding quotes are
  removed before substrings are added to Strings.
  Note:	Characters contained in Separators or WhiteSpace are treated as part of a value substring if the substring is surrounded by single
  or double quote marks. HTTP escape characters are converted using the HTTPDecode function. }
procedure ALExtractHTTPFields(Separators, WhiteSpace, Quotes: TSysCharSet;
  Content: PAnsiChar; Strings: TALStrings; StripQuotes: Boolean = False);
begin
  ALExtractHeaderFields(Separators, WhiteSpace, Quotes, Content, Strings, True,
    StripQuotes);
end;

{ ******************************************************** }
{ Parses a multi-valued string into its constituent fields.
  ExtractHeaderFields is a general utility to parse multi-valued HTTP header strings into separate substrings.
  * Separators is a set of characters that are used to separate individual values within the multi-valued string.
  * WhiteSpace is a set of characters that are to be ignored when parsing the string.
  * Content is the multi-valued string to be parsed.
  * Strings is the TStrings object that receives the individual values that are parsed from Content.
  * StripQuotes determines whether the surrounding quotes are removed from the resulting items. When StripQuotes is true, surrounding quotes are removed
  before substrings are added to Strings.
  Note:	Characters contained in Separators or WhiteSpace are treated as part of a value substring if the substring is surrounded by single or double quote
  marks. HTTP escape characters are converted using the ALHTTPDecode function. }
procedure ALExtractHeaderFields(Separators, WhiteSpace, Quotes: TSysCharSet;
  Content: PAnsiChar; Strings: TALStrings; Decode: Boolean;
  StripQuotes: Boolean = False);

var
  Head, Tail: PAnsiChar;
  EOS, InQuote, LeadQuote: Boolean;
  QuoteChar: ansiChar;
  ExtractedField: AnsiString;
  SeparatorsWithQuotesAndNulChar: TSysCharSet;
  QuotesWithNulChar: TSysCharSet;

  { ------------------------------------------------------ }
  function DoStripQuotes(const S: AnsiString): AnsiString;
  var
    i: Integer;
    InStripQuote: Boolean;
    StripQuoteChar: ansiChar;
  begin
    Result := S;
    InStripQuote := False;
    StripQuoteChar := #0;
    if StripQuotes then
      for i := Length(Result) downto 1 do
        if Result[i] in Quotes then
          if InStripQuote and (StripQuoteChar = Result[i]) then
          begin
            Delete(Result, i, 1);
            InStripQuote := False;
          end
          else if not InStripQuote then
          begin
            StripQuoteChar := Result[i];
            InStripQuote := True;
            Delete(Result, i, 1);
          end
  end;

Begin
  if (Content = nil) or (Content^ = #0) then
    exit;
  SeparatorsWithQuotesAndNulChar := Separators + Quotes + [#0];
  QuotesWithNulChar := Quotes + [#0];
  Tail := Content;
  QuoteChar := #0;
  repeat
    while Tail^ in WhiteSpace do
      Inc(Tail);
    Head := Tail;
    InQuote := False;
    LeadQuote := False;
    while True do
    begin
      while (InQuote and not(Tail^ in QuotesWithNulChar)) or
        not(Tail^ in SeparatorsWithQuotesAndNulChar) do
        Inc(Tail);
      if Tail^ in Quotes then
      begin
        if (QuoteChar <> #0) and (QuoteChar = Tail^) then
          QuoteChar := #0
        else If QuoteChar = #0 then
        begin
          LeadQuote := Head = Tail;
          QuoteChar := Tail^;
          if LeadQuote then
            Inc(Head);
        end;
        InQuote := QuoteChar <> #0;
        if InQuote then
          Inc(Tail)
        else
          Break;
      end
      else
        Break;
    end;
    if not LeadQuote and (Tail^ <> #0) and (Tail^ in Quotes) then
      Inc(Tail);
    EOS := Tail^ = #0;
    if Head^ <> #0 then
    begin
      SetString(ExtractedField, Head, Tail - Head);
      if Decode then
        Strings.Add(ALHTTPDecode(DoStripQuotes(ExtractedField)))
      else
        Strings.Add(DoStripQuotes(ExtractedField));
    end;
    Inc(Tail);
  until EOS;
end;

{ ************************************************************************************** }
{ same as ALExtractHeaderFields except the it take care or escaped quote (like '' or "") }
procedure ALExtractHeaderFieldsWithQuoteEscaped(Separators, WhiteSpace,
  Quotes: TSysCharSet; Content: PAnsiChar; Strings: TALStrings; Decode: Boolean;
  StripQuotes: Boolean = False);

var
  Head, Tail, NextTail: PAnsiChar;
  EOS, InQuote, LeadQuote: Boolean;
  QuoteChar: ansiChar;
  ExtractedField: AnsiString;
  SeparatorsWithQuotesAndNulChar: TSysCharSet;
  QuotesWithNulChar: TSysCharSet;

  { ------------------------------------------------------ }
  function DoStripQuotes(const S: AnsiString): AnsiString;
  var
    i: Integer;
    InStripQuote: Boolean;
    StripQuoteChar: ansiChar;
  begin
    Result := S;
    InStripQuote := False;
    StripQuoteChar := #0;
    if StripQuotes then
    begin
      i := Length(Result);
      while i > 0 do
      begin
        if Result[i] in Quotes then
        begin
          if InStripQuote and (StripQuoteChar = Result[i]) then
          begin
            Delete(Result, i, 1);
            if (i > 1) and (Result[i - 1] = StripQuoteChar) then
              dec(i)
            else
              InStripQuote := False;
          end
          else if not InStripQuote then
          begin
            StripQuoteChar := Result[i];
            InStripQuote := True;
            Delete(Result, i, 1);
          end
        end;
        dec(i);
      end;
    end;
  end;

Begin
  if (Content = nil) or (Content^ = #0) then
    exit;
  SeparatorsWithQuotesAndNulChar := Separators + Quotes + [#0];
  QuotesWithNulChar := Quotes + [#0];
  Tail := Content;
  QuoteChar := #0;
  repeat
    while Tail^ in WhiteSpace do
      Inc(Tail);
    Head := Tail;
    InQuote := False;
    LeadQuote := False;
    while True do
    begin
      while (InQuote and not(Tail^ in QuotesWithNulChar)) or
        not(Tail^ in SeparatorsWithQuotesAndNulChar) do
        Inc(Tail);
      if Tail^ in Quotes then
      begin
        if (QuoteChar <> #0) and (QuoteChar = Tail^) then
        begin
          NextTail := Tail + 1;
          if NextTail^ = Tail^ then
            Inc(Tail)
          else
            QuoteChar := #0;
        end
        else If QuoteChar = #0 then
        begin
          LeadQuote := Head = Tail;
          QuoteChar := Tail^;
          if LeadQuote then
            Inc(Head);
        end;
        InQuote := QuoteChar <> #0;
        if InQuote then
          Inc(Tail)
        else
          Break;
      end
      else
        Break;
    end;
    if not LeadQuote and (Tail^ <> #0) and (Tail^ in Quotes) then
      Inc(Tail);
    EOS := Tail^ = #0;
    if Head^ <> #0 then
    begin
      SetString(ExtractedField, Head, Tail - Head);
      if Decode then
        Strings.Add(ALHTTPDecode(DoStripQuotes(ExtractedField)))
      else
        Strings.Add(DoStripQuotes(ExtractedField));
    end;
    Inc(Tail);
  until EOS;
end;

{ *********************************************************** }
Function AlRemoveShemeFromUrl(aUrl: AnsiString): AnsiString;
Var
  P: Integer;
begin
  P := AlPos('://', aUrl);
  if P > 0 then
    Result := AlCopyStr(aUrl, P + 3, MaxInt)
  else
    Result := aUrl;
end;

{ **************************************************************** }
Function AlExtractShemeFromUrl(aUrl: AnsiString): TInternetScheme;
Var
  SchemeName, HostName, UserName, Password, UrlPath, ExtraInfo: AnsiString;
var
  PortNumber: Integer;
begin
  if AlInternetCrackUrl(aUrl, SchemeName, HostName, UserName, Password, UrlPath,
    ExtraInfo, PortNumber) then
  begin
    if ALSameText(SchemeName, 'http') then
      Result := INTERNET_SCHEME_HTTP
    else if ALSameText(SchemeName, 'https') then
      Result := INTERNET_SCHEME_HTTPS
    else if ALSameText(SchemeName, 'ftp') then
      Result := INTERNET_SCHEME_FTP
    else
      Result := INTERNET_SCHEME_UNKNOWN;
  end
  else
    Result := INTERNET_SCHEME_UNKNOWN;
end;

{ ************************************************************** }
Function AlExtractHostNameFromUrl(aUrl: AnsiString): AnsiString;
Var
  SchemeName, HostName, UserName, Password, UrlPath, ExtraInfo: AnsiString;
  PortNumber: Integer;
begin
  if AlInternetCrackUrl(aUrl, SchemeName, HostName, UserName, Password, UrlPath,
    ExtraInfo, PortNumber) then
    Result := HostName
  else
    Result := '';
end;

{ **************************************************************** }
Function AlExtractDomainNameFromUrl(aUrl: AnsiString): AnsiString;
var
  aIPv4Num: Cardinal;
begin
  Result := AlExtractHostNameFromUrl(aUrl);
  if not ALTryIPV4StrToNumeric(Result, aIPv4Num) then
  begin
    while Length(AlStringReplace(Result, '.', '', [rfReplaceAll])) <
      Length(Result) - 1 do
      Delete(Result, 1, AlPos('.', Result));
  end;
end;

{ ************************************************************** }
Function AlExtractUrlPathFromUrl(aUrl: AnsiString): AnsiString;
Var
  SchemeName, HostName, UserName, Password, UrlPath, ExtraInfo: AnsiString;
  PortNumber: Integer;
begin
  if AlInternetCrackUrl(aUrl, SchemeName, HostName, UserName, Password, UrlPath,
    ExtraInfo, PortNumber) then
    Result := UrlPath
  else
    Result := '';
end;

{ ******************************************** }
Function AlInternetCrackUrl(aUrl: AnsiString;
  Var SchemeName, HostName, UserName, Password, UrlPath, ExtraInfo: AnsiString;
  var PortNumber: Integer): Boolean;
Var
  P1, P2: Integer;
  S1: AnsiString;
begin
  SchemeName := '';
  HostName := '';
  UserName := '';
  Password := '';
  UrlPath := '';
  ExtraInfo := '';
  PortNumber := 0;
  Result := True;

  P1 := AlPos('://', aUrl);
  // ftp://xxxx:yyyyy@ftp.yoyo.com:21/path/filename.xxx?param1=value1
  if P1 > 0 then
  begin
    SchemeName := AlCopyStr(aUrl, 1, P1 - 1); // ftp
    Delete(aUrl, 1, P1 + 2);
    // xxxx:yyyyy@ftp.yoyo.com:21/path/filename.xxx?param1=value1
    P1 := AlPos('?', aUrl);
    if P1 > 0 then
    begin
      ExtraInfo := AlCopyStr(aUrl, P1, MaxInt); // ?param1=value1
      Delete(aUrl, P1, MaxInt); // xxxx:yyyyy@ftp.yoyo.com:21/path/filename.xxx
    end;
    P1 := AlPos('/', aUrl);
    if P1 > 0 then
    begin
      UrlPath := AlCopyStr(aUrl, P1, MaxInt); // /path/filename.xxx
      Delete(aUrl, P1, MaxInt); // xxxx:yyyyy@ftp.yoyo.com:21
    end;
    P1 := ALLastDelimiter('@', aUrl);
    if P1 > 0 then
    begin
      S1 := AlCopyStr(aUrl, 1, P1 - 1); // xxxx:yyyyy
      Delete(aUrl, 1, P1); // ftp.yoyo.com:21
      P1 := AlPos(':', S1);
      if P1 > 0 then
      begin
        UserName := AlCopyStr(S1, 1, P1 - 1); // xxxx
        Password := AlCopyStr(S1, P1 + 1, MaxInt); // yyyyy
      end
      else
      begin
        UserName := S1;
        Password := '';
      end;
    end;
    P2 := AlPos(']', aUrl); // to handle ipV6 url like [::1]:8080
    P1 := AlPosEx(':', aUrl, P2 + 1);
    if P1 > 0 then
    begin
      S1 := AlCopyStr(aUrl, P1 + 1, MaxInt); // 21
      Delete(aUrl, P1, MaxInt); // ftp.yoyo.com
      if not ALTryStrToInt(S1, PortNumber) then
        PortNumber := 0;
    end;
    if PortNumber = 0 then
    begin
      if ALSameText(SchemeName, 'http') then
        PortNumber := 80
      else if ALSameText(SchemeName, 'https') then
        PortNumber := 443
      else if ALSameText(SchemeName, 'ftp') then
        PortNumber := 21
      else
        Result := False;
    end;
    if Result then
    begin
      HostName := aUrl;
      Result := HostName <> '';
    end;
  end
  else
    Result := False;

  if not Result then
  begin
    SchemeName := '';
    HostName := '';
    UserName := '';
    Password := '';
    UrlPath := '';
    ExtraInfo := '';
    PortNumber := 0;
  end;
end;

{ ******************************************* }
Function AlInternetCrackUrl(aUrl: AnsiString;
  Var SchemeName, HostName, UserName, Password, UrlPath, Anchor: AnsiString;
  // not the anchor is never send to the server ! it's only used on client side
  Query: TALStrings; var PortNumber: Integer): Boolean;
var
  aExtraInfo: AnsiString;
  P1: Integer;
begin
  Result := AlInternetCrackUrl(aUrl, SchemeName, HostName, UserName, Password,
    UrlPath, aExtraInfo, PortNumber);
  if Result then
  begin
    P1 := AlPos('#', aExtraInfo);
    if P1 > 0 then
    begin
      Anchor := AlCopyStr(aExtraInfo, P1 + 1, MaxInt);
      Delete(aExtraInfo, P1, MaxInt);
    end
    else
      Anchor := '';
    if (aExtraInfo <> '') and (aExtraInfo[1] = '?') then
    begin
{$IF CompilerVersion >= 18.5}
      if AlPos('&amp;', aExtraInfo) > 0 then
        Query.LineBreak := '&amp;'
      else
        Query.LineBreak := '&';
      Query.Text := AlCopyStr(aExtraInfo, 2, MaxInt);
{$ELSE}
      if AlPos('&amp;', aExtraInfo) > 0 then
        Query.Text := AlStringReplace(AlCopyStr(aExtraInfo, 2, MaxInt), '&amp;',
          #13#10, [rfReplaceAll])
      else
        Query.Text := AlStringReplace(AlCopyStr(aExtraInfo, 2, MaxInt), '&',
          #13#10, [rfReplaceAll]);
{$IFEND}
    end
    else
      Query.Clear;
  end
  else
  begin
    Anchor := '';
    Query.Clear;
  end;

end;

{ *********************************************** }
Function AlInternetCrackUrl(var URL: AnsiString;
  // if true return the relative url
  var Anchor: AnsiString; Query: TALStrings): Boolean;
Var
  SchemeName, HostName, UserName, Password, UrlPath: AnsiString;
  PortNumber: Integer;
  tmpUrl: AnsiString;
begin

  // exit if no url
  if URL = '' then
  begin
    Result := False;
    exit;
  end;

  // first try with full url
  Result := AlInternetCrackUrl(URL, SchemeName, HostName, UserName, Password,
    UrlPath, Anchor, Query, PortNumber);
  if Result then
    URL := UrlPath

    // try with relative url
  else
  begin
    tmpUrl := URL;
    if tmpUrl[1] = '/' then
      tmpUrl := 'http://www.arkadia.com' + tmpUrl
      // we don't take care of the domaine name, it's will be skip, it's just to make the url valid
    else
      tmpUrl := 'http://www.arkadia.com/' + tmpUrl;
    Result := AlInternetCrackUrl(tmpUrl, SchemeName, HostName, UserName,
      Password, UrlPath, Anchor, Query, PortNumber);
    if Result then
      URL := UrlPath;
  end;

end;

{ ************************************************************************************ }
Function AlRemoveAnchorFromUrl(aUrl: AnsiString; Var aAnchor: AnsiString)
  : AnsiString;
Var
  P1: Integer;
begin
  P1 := AlPos('#', aUrl);
  if P1 > 0 then
  begin
    aAnchor := AlCopyStr(aUrl, P1 + 1, MaxInt);
    Delete(aUrl, P1, MaxInt);
  end
  else
    aAnchor := '';
  Result := aUrl;
end;

{ *********************************************************** }
Function AlRemoveAnchorFromUrl(aUrl: AnsiString): AnsiString;
var
  aAnchor: AnsiString;
begin
  Result := AlRemoveAnchorFromUrl(aUrl, aAnchor);
end;

{ ****************************************************************** }
function AlCombineUrl(RelativeUrl, BaseUrl: AnsiString): AnsiString;
var
  Size: Dword;
  Buffer: AnsiString;
begin
  case AlExtractShemeFromUrl(RelativeUrl) of

    { relative path.. so try to combine the url }
    INTERNET_SCHEME_PARTIAL, INTERNET_SCHEME_UNKNOWN, INTERNET_SCHEME_DEFAULT:
      begin
        Size := INTERNET_MAX_URL_LENGTH;
        SetLength(Buffer, Size);
        if InternetCombineUrlA(PAnsiChar(BaseUrl), PAnsiChar(RelativeUrl),
          @Buffer[1], Size, ICU_BROWSER_MODE or ICU_no_encode) then
          Result := AlCopyStr(Buffer, 1, Size)
        else
          Result := RelativeUrl;
      end;

    { not a relative path }
  else
    Result := RelativeUrl;

  end;
end;

{ ********************************* }
Function AlCombineUrl(RelativeUrl, BaseUrl, Anchor: AnsiString;
  Query: TALStrings): AnsiString;
Var
  S1: AnsiString;
{$IF CompilerVersion >= 18.5}
  aBool: Boolean;
{$IFEND}
begin
  if Query.Count > 0 then
  begin

{$IF CompilerVersion >= 18.5}
    if Query.LineBreak = #13#10 then
    begin
      aBool := True;
      Query.LineBreak := '&';
    end
    else
      aBool := False;

    try

      S1 := ALTrim(Query.Text);
      while AlPos(Query.LineBreak, S1) = 1 do
        Delete(S1, 1, Length(Query.LineBreak));
      while AlPosEx(Query.LineBreak, S1, Length(S1) - Length(Query.LineBreak) +
        1) > 0 do
        Delete(S1, Length(S1) - Length(Query.LineBreak) + 1, MaxInt);
      if S1 <> '' then
        S1 := '?' + S1;

    finally
      if aBool then
        Query.LineBreak := #13#10;
    end;
{$ELSE}
    S1 := AlStringReplace(ALTrim(Query.Text), #13#10, '&', [rfReplaceAll]);
    while AlPos('&', S1) = 1 do
      Delete(S1, 1, 1);
    while AlPosEx('&', S1, Length(S1)) > 0 do
      Delete(S1, Length(S1), MaxInt);
    if S1 <> '' then
      S1 := '?' + S1;
{$IFEND}
  end
  else
    S1 := '';

  if Anchor <> '' then
    S1 := S1 + '#' + Anchor;

  Result := AlCombineUrl(RelativeUrl + S1, BaseUrl);
end;

{ ********************************************************************* }
{ aValue is a GMT TDateTime - result is "Sun, 06 Nov 1994 08:49:37 GMT" }
function ALGmtDateTimeToRfc822Str(const aValue: TDateTime): AnsiString;
var
  aDay, aMonth, aYear: Word;
begin
  DecodeDate(aValue, aYear, aMonth, aDay);

  Result := ALFormat('%s, %.2d %s %.4d %s %s',
    [CAlRfc822DayOfWeekNames[DayOfWeek(aValue)], aDay,
    CALRfc822MonthOfTheYearNames[aMonth], aYear,
    ALFormatDateTime('hh":"nn":"ss', aValue, ALDefaultFormatSettings), 'GMT']);
end;

{ *********************************************************************** }
{ aValue is a Local TDateTime - result is "Sun, 06 Nov 1994 08:49:37 GMT" }
function ALDateTimeToRfc822Str(const aValue: TDateTime): AnsiString;
begin
  Result := ALGmtDateTimeToRfc822Str(AlLocalDateTimeToGMTDateTime(aValue));
end;

{ ************************************************************ }
{ Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
  the function allow also date like "Sun, 06-Nov-1994 08:49:37 GMT"
  to be compatible with cookies field (http://wp.netscape.com/newsref/std/cookie_spec.html)

  The "Date" line (formerly "Posted") is the date that the message was
  originally posted to the network.  Its format must be acceptable
  both in RFC-822 and to the getdate(3) routine that is provided with
  the Usenet software.  This date remains unchanged as the message is
  propagated throughout the network.  One format that is acceptable to
  both is:

  Wdy, DD Mon YY HH:MM:SS TIMEZONE

  Several examples of valid dates appear in the sample message above.
  Note in particular that ctime(3) format:

  Wdy Mon DD HH:MM:SS YYYY

  is not acceptable because it is not a valid RFC-822 date.  However,
  since older software still generates this format, news
  implementations are encouraged to accept this format and translate
  it into an acceptable format.

  There is no hope of having a complete list of timezones.  Universal
  Time (GMT), the North American timezones (PST, PDT, MST, MDT, CST,
  CDT, EST, EDT) and the +/-hhmm offset specifed in RFC-822 should be
  supported.  It is recommended that times in message headers be
  transmitted in GMT and displayed in the local time zone. }
Function ALTryRfc822StrToGMTDateTime(const S: AnsiString;
  out Value: TDateTime): Boolean;

{ -------------------------------------------------------------------------- }
  Function InternalMonthWithLeadingChar(const aMonth: AnsiString): AnsiString;
  Begin
    If Length(aMonth) = 1 then
      Result := '0' + aMonth
    else
      Result := aMonth;
  end;

Var
  P1, P2: Integer;
  ADateStr: AnsiString;
  aLst: TALStringList;
  aMonthLabel: AnsiString;
  aFormatSettings: TALformatSettings;
  aTimeZoneStr: AnsiString;
  aTimeZoneDelta: TDateTime;

Begin

  ADateStr := S; // Wdy, DD-Mon-YYYY HH:MM:SS GMT
  // Wdy, DD-Mon-YYYY HH:MM:SS +0200
  // 23 Aug 2004 06:48:46 -0700
  P1 := AlPos(',', ADateStr);
  If P1 > 0 then
    Delete(ADateStr, 1, P1); // DD-Mon-YYYY HH:MM:SS GMT
  // DD-Mon-YYYY HH:MM:SS +0200
  // 23 Aug 2004 06:48:46 -0700
  ADateStr := ALTrim(ADateStr); // DD-Mon-YYYY HH:MM:SS GMT
  // DD-Mon-YYYY HH:MM:SS +0200
  // 23 Aug 2004 06:48:46 -0700

  P1 := AlPos(':', ADateStr);
  P2 := AlPos('-', ADateStr);
  While (P2 > 0) and (P2 < P1) do
  begin
    ADateStr[P2] := ' ';
    P2 := AlPosEx('-', ADateStr, P2);
  end; // DD Mon YYYY HH:MM:SS GMT
  // DD Mon YYYY HH:MM:SS +0200
  // 23 Aug 2004 06:48:46 -0700
  While AlPos('  ', ADateStr) > 0 do
    ADateStr := AlStringReplace(ADateStr, '  ', ' ', [rfReplaceAll]);
  // DD Mon YYYY HH:MM:SS GMT
  // DD Mon YYYY HH:MM:SS +0200
  // 23 Aug 2004 06:48:46 -0700

  aLst := TALStringList.Create;
  Try

    aLst.Text := AlStringReplace(ADateStr, ' ', #13#10, [rfReplaceAll]);
    If aLst.Count < 5 then
    begin
      Result := False;
      exit;
    end;

    aMonthLabel := ALTrim(aLst[1]); // Mon
    // Mon
    // Aug
    P1 := 1;
    While (P1 <= 12) and (not ALSameText(CALRfc822MonthOfTheYearNames[P1],
      aMonthLabel)) do
      Inc(P1);
    If P1 > 12 then
    begin
      Result := False;
      exit;
    end;

    aFormatSettings := ALDefaultFormatSettings;
    aFormatSettings.DateSeparator := '/';
    aFormatSettings.TimeSeparator := ':';
    aFormatSettings.ShortDateFormat := 'dd/mm/yyyy';
    aFormatSettings.ShortTimeFormat := 'hh:nn:zz';

    aTimeZoneStr := ALTrim(aLst[4]); // GMT
    // +0200
    // -0700
    aTimeZoneStr := AlStringReplace(aTimeZoneStr, '(', '', []);
    aTimeZoneStr := AlStringReplace(aTimeZoneStr, ')', '', []);
    aTimeZoneStr := ALTrim(aTimeZoneStr);
    If aTimeZoneStr = '' then
    Begin
      Result := False;
      exit;
    end
    else If (Length(aTimeZoneStr) >= 5) and (aTimeZoneStr[1] in ['+', '-']) and
      (aTimeZoneStr[2] in ['0' .. '9']) and (aTimeZoneStr[3] in ['0' .. '9'])
      and (aTimeZoneStr[4] in ['0' .. '9']) and (aTimeZoneStr[5] in ['0' .. '9'])
    then
    begin
      aTimeZoneDelta := ALStrToDateTime(AlCopyStr(aTimeZoneStr, 2, 2) + ':' +
        AlCopyStr(aTimeZoneStr, 4, 2) + ':00', aFormatSettings);
      if aTimeZoneStr[1] = '+' then
        aTimeZoneDelta := -1 * aTimeZoneDelta;
    end
    else If ALSameText(aTimeZoneStr, 'GMT') then
      aTimeZoneDelta := 0
    else If ALSameText(aTimeZoneStr, 'UTC') then
      aTimeZoneDelta := 0
    else If ALSameText(aTimeZoneStr, 'UT') then
      aTimeZoneDelta := 0
    else If ALSameText(aTimeZoneStr, 'EST') then
      aTimeZoneDelta := ALStrToDateTime('05:00:00', aFormatSettings)
    else If ALSameText(aTimeZoneStr, 'EDT') then
      aTimeZoneDelta := ALStrToDateTime('04:00:00', aFormatSettings)
    else If ALSameText(aTimeZoneStr, 'CST') then
      aTimeZoneDelta := ALStrToDateTime('06:00:00', aFormatSettings)
    else If ALSameText(aTimeZoneStr, 'CDT') then
      aTimeZoneDelta := ALStrToDateTime('05:00:00', aFormatSettings)
    else If ALSameText(aTimeZoneStr, 'MST') then
      aTimeZoneDelta := ALStrToDateTime('07:00:00', aFormatSettings)
    else If ALSameText(aTimeZoneStr, 'MDT') then
      aTimeZoneDelta := ALStrToDateTime('06:00:00', aFormatSettings)
    else If ALSameText(aTimeZoneStr, 'PST') then
      aTimeZoneDelta := ALStrToDateTime('08:00:00', aFormatSettings)
    else If ALSameText(aTimeZoneStr, 'PDT') then
      aTimeZoneDelta := ALStrToDateTime('07:00:00', aFormatSettings)
    else
    begin
      Result := False;
      exit;
    end;

    ADateStr := ALTrim(aLst[0]) + '/' + InternalMonthWithLeadingChar
      (ALIntToStr(P1)) + '/' + ALTrim(aLst[2]) + ' ' + ALTrim(aLst[3]);
    // DD/MM/YYYY HH:MM:SS
    Result := ALTryStrToDateTime(ADateStr, Value, aFormatSettings);
    If Result then
      Value := Value + aTimeZoneDelta;

  finally
    aLst.free;
  end;

end;

{ ************************************************************* }
{ Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
  the function allow also date like "Sun, 06-Nov-1994 08:49:37 GMT"
  to be compatible with cookies field (http://wp.netscape.com/newsref/std/cookie_spec.html) }
function ALRfc822StrToGMTDateTime(const S: AnsiString): TDateTime;
Begin
  if not ALTryRfc822StrToGMTDateTime(S, Result) then
    raise EConvertError.CreateResFmt(@SInvalidDateTime, [S]);
end;

{ ************************************************************************************ }
Function ALTryIPV4StrToNumeric(aIPv4Str: AnsiString;
  var aIPv4Num: Cardinal): Boolean;
Var
  P1, P2: Integer;
  I1, I2, I3, I4: Integer;
Begin

  // ----------
  if aIPv4Str = '' then
  begin
    Result := False;
    exit;
  end;

  // ----------
  P1 := 1;
  P2 := AlPosEx('.', aIPv4Str, P1);
  if (P2 <= P1) or (not ALTryStrToInt(AlCopyStr(aIPv4Str, P1, P2 - P1), I1)) or
    (not(I1 in [0 .. 255])) then
  begin
    Result := False;
    exit;
  end;

  // ----------
  P1 := P2 + 1;
  P2 := AlPosEx('.', aIPv4Str, P1);
  if (P2 <= P1) or (not ALTryStrToInt(AlCopyStr(aIPv4Str, P1, P2 - P1), I2)) or
    (not(I2 in [0 .. 255])) then
  begin
    Result := False;
    exit;
  end;

  // ----------
  P1 := P2 + 1;
  P2 := AlPosEx('.', aIPv4Str, P1);
  if (P2 <= P1) or (not ALTryStrToInt(AlCopyStr(aIPv4Str, P1, P2 - P1), I3)) or
    (not(I3 in [0 .. 255])) then
  begin
    Result := False;
    exit;
  end;

  // ----------
  P1 := P2 + 1;
  P2 := Length(aIPv4Str) + 1;
  if (P2 <= P1) or (not ALTryStrToInt(AlCopyStr(aIPv4Str, P1, P2 - P1), I4)) or
    (not(I4 in [0 .. 255])) then
  begin
    Result := False;
    exit;
  end;

  // ----------
  Result := True;
  aIPv4Num := (Cardinal(I1) * 256 * 256 * 256) + (Cardinal(I2) * 256 * 256) +
    (Cardinal(I3) * 256) + (Cardinal(I4));

End;

{ ******************************************************* }
Function ALIPV4StrToNumeric(aIPv4: AnsiString): Cardinal;
Begin
  if not ALTryIPV4StrToNumeric(aIPv4, Result) then
    Raise EALException.Create('Bad IPv4 string: ' + aIPv4);
End;

{ ******************************************************* }
Function ALNumericToIPv4Str(aIPv4: Cardinal): AnsiString;
Var
  S1, S2, S3, S4: AnsiString;
Begin

  S1 := ALIntToStr((aIPv4 div (256 * 256 * 256)) mod 256);
  S2 := ALIntToStr((aIPv4 div (256 * 256)) mod 256);
  S3 := ALIntToStr((aIPv4 div (256)) mod 256);
  S4 := ALIntToStr((aIPv4) mod 256);

  Result := S1 + '.' + S2 + '.' + S3 + '.' + S4;

End;

{ ********************************* }
Function ALZeroIpV6: TALIPv6Binary;
begin
  FillChar(Result, 16, #0);
end;

{ **************************************************************************************** }
Function ALTryIPV6StrToBinary(aIPv6Str: AnsiString;
  var aIPv6Bin: TALIPv6Binary): Boolean;
var
  aLstIpv6Part: TALStringList;
  S1: AnsiString;
  P1: Integer;
  i: Integer;
begin

  // ----------
  if aIPv6Str = '' then
  begin
    Result := False;
    exit;
  end;

  // http://msdn.microsoft.com/en-us/library/aa921042.aspx
  // Zero compression can be used only once in an address, which enables you to determine
  // the number of 0 bits represented by each instance of a double-colon (::).
  P1 := AlPos('::', aIPv6Str);
  if (P1 > 0) and (AlPosEx('::', aIPv6Str, P1 + 1) > 0) then
  begin
    Result := False;
    exit;
  end
  else if P1 = 1 then
    Delete(aIPv6Str, 1, 1); // with the exemple below, we have one extra ":"
  // ::D3:0000:2F3B:02AA:00FF:FE28:9C5A => 0:D3:0000:2F3B:02AA:00FF:FE28:9C5A
  // but with the exemple below ok because the last #13#10 will be trim when we will do
  // aLstIpv6Part.Text := AlStringReplace(aIPv6Str, ':', #13#10, [rfReplaceALL]);
  // 21DA:D3:0000:2F3B:02AA:00FF:FE28:: => 21DA:D3:0000:2F3B:02AA:00FF:FE28:0

  // ----------
  aLstIpv6Part := TALStringList.Create;
  try

    // ----------
    aLstIpv6Part.Text := AlStringReplace(aIPv6Str, ':', #13#10, [rfReplaceAll]);

    // ----------
    if (aLstIpv6Part.Count > 8) then
    begin
      Result := False;
      exit;
    end;

    // http://msdn.microsoft.com/en-us/library/aa921042.aspx
    // IPv6 representation can be further simplified by removing the leading zeros within each 16-bit block.
    // However, each block must have at least a single digit. The following example shows the address without
    // the leading zeros
    // 21DA:D3:0:2F3B:2AA:FF:FE28:9C5A => 21DA:D3:0000:2F3B:02AA:00FF:FE28:9C5A
    //
    // Some types of addresses contain long sequences of zeros. In IPv6 addresses, a contiguous sequence of
    // 16-bit blocks set to 0 in the colon-hexadecimal format can be compressed to :: (known as double-colon).
    // The following list shows examples of compressing zeros
    // FF02::2 => FF02:0:0:0:0:0:0:2
    i := 0;
    while i <= 7 do
    begin
      if i >= aLstIpv6Part.Count then
      begin
        Result := False;
        exit;
      end
      else if (aLstIpv6Part[i] = '') then
      begin
        aLstIpv6Part[i] := '0000';
        while aLstIpv6Part.Count < 8 do
        begin
          aLstIpv6Part.Insert(i, '0000');
          Inc(i);
        end;
      end
      else
      begin
        if Length(aLstIpv6Part[i]) > 4 then
        begin
          Result := False;
          exit;
        end
        else if Length(aLstIpv6Part[i]) < 4 then
        begin
          SetLength(S1, 4 - Length(aLstIpv6Part[i]));
          FillChar(S1[1], Length(S1), '0');
          aLstIpv6Part[i] := S1 + aLstIpv6Part[i];
        end;
      end;
      Inc(i);
    end;

    // ----------
    for i := 0 to aLstIpv6Part.Count - 1 do
    begin

      S1 := AlUpperCase(AlCopyStr(aLstIpv6Part[i], 1, 2));
      if (not ALTryStrToInt('$' + S1, P1)) or (not(P1 in [0 .. 255])) then
      begin
        Result := False;
        exit;
      end;
      aIPv6Bin[(i * 2) + 1] := ansiChar(P1);

      S1 := AlUpperCase(AlCopyStr(aLstIpv6Part[i], 3, 2));
      if (not ALTryStrToInt('$' + S1, P1)) or (not(P1 in [0 .. 255])) then
      begin
        Result := False;
        exit;
      end;
      aIPv6Bin[(i * 2) + 2] := ansiChar(P1);

    end;

    Result := True;

  finally
    aLstIpv6Part.free;
  end;

end;

{ *********************************************************** }
Function ALIPV6StrTobinary(aIPv6: AnsiString): TALIPv6Binary;
Begin
  if not ALTryIPV6StrToBinary(aIPv6, Result) then
    Raise EALException.Create('Bad IPv6 string: ' + aIPv6);
End;

{ *********************************************************** }
Function ALBinaryToIPv6Str(aIPv6: TALIPv6Binary): AnsiString;
Begin

  Result := ALIntToHex(ord(aIPv6[1]), 2) + ALIntToHex(ord(aIPv6[2]), 2) + ':' +
    ALIntToHex(ord(aIPv6[3]), 2) + ALIntToHex(ord(aIPv6[4]), 2) + ':' +
    ALIntToHex(ord(aIPv6[5]), 2) + ALIntToHex(ord(aIPv6[6]), 2) + ':' +
    ALIntToHex(ord(aIPv6[7]), 2) + ALIntToHex(ord(aIPv6[8]), 2) + ':' +
    ALIntToHex(ord(aIPv6[9]), 2) + ALIntToHex(ord(aIPv6[10]), 2) + ':' +
    ALIntToHex(ord(aIPv6[11]), 2) + ALIntToHex(ord(aIPv6[12]), 2) + ':' +
    ALIntToHex(ord(aIPv6[13]), 2) + ALIntToHex(ord(aIPv6[14]), 2) + ':' +
    ALIntToHex(ord(aIPv6[15]), 2) + ALIntToHex(ord(aIPv6[16]), 2);

End;

{ ************************************************************************** }
Function ALBinaryStrToIPv6Binary(aIPV6BinaryStr: AnsiString): TALIPv6Binary;
Begin

  if Length(aIPV6BinaryStr) <> 16 then
    Raise EALException.Create('Bad IPv6 binary string');
  Result[1] := aIPV6BinaryStr[1];
  Result[2] := aIPV6BinaryStr[2];
  Result[3] := aIPV6BinaryStr[3];
  Result[4] := aIPV6BinaryStr[4];
  Result[5] := aIPV6BinaryStr[5];
  Result[6] := aIPV6BinaryStr[6];
  Result[7] := aIPV6BinaryStr[7];
  Result[8] := aIPV6BinaryStr[8];
  Result[9] := aIPV6BinaryStr[9];
  Result[10] := aIPV6BinaryStr[10];
  Result[11] := aIPV6BinaryStr[11];
  Result[12] := aIPV6BinaryStr[12];
  Result[13] := aIPV6BinaryStr[13];
  Result[14] := aIPV6BinaryStr[14];
  Result[15] := aIPV6BinaryStr[15];
  Result[16] := aIPV6BinaryStr[16];

End;

{ *********************************************************************************** }
constructor EALHTTPClientException.Create(const Msg: AnsiString;
  SCode: Integer = 0);
begin
  inherited Create(String(Msg));
  FStatusCode := SCode;
end;

{ ****************************************************************************************************************** }
constructor EALHTTPClientException.CreateFmt(const Msg: AnsiString;
  const Args: array of const; SCode: Integer = 0);
begin
  inherited CreateFmt(String(Msg), Args);
  FStatusCode := SCode;
end;

{ ******************************* }
constructor TALHTTPClient.Create;
begin
  inherited;
  FUploadBufferSize := $8000;
  FConnectTimeout := 0;
  FSendTimeout := 0;
  FReceiveTimeout := 0;
  FURL := '';
  FUserName := '';
  FPassword := '';
  FOnUploadProgress := nil;
  FOnDownloadProgress := nil;
  FOnRedirect := nil;
  FProxyParams := TALHTTPClientProxyParams.Create;
  FRequestHeader := TALHTTPRequestHeader.Create;
  FRequestHeader.UserAgent := 'Mozilla/3.0 (compatible; TALHTTPClient)';
  FProtocolVersion := HTTPpv_1_1;
  FRequestMethod := HTTPmt_Get;
  FRequestHeader.OnChange := OnRequestHeaderChange;
  FProxyParams.OnChange := OnProxyParamsChange;
end;

{ ******************************* }
destructor TALHTTPClient.Destroy;
begin
  FProxyParams.free;
  FRequestHeader.free;
  inherited;
end;

{ ****************************************************** }
procedure TALHTTPClient.SetURL(const Value: AnsiString);
begin
  FURL := Value;
end;

{ *************************************************************** }
procedure TALHTTPClient.SetUsername(const NameValue: AnsiString);
begin
  FUserName := NameValue;
end;

{ ***************************************************************************** }
procedure TALHTTPClient.SetOnRedirect(const Value: TAlHTTPClientRedirectEvent);
begin
  FOnRedirect := Value;
end;

{ ******************************************************************* }
procedure TALHTTPClient.SetPassword(const PasswordValue: AnsiString);
begin
  FPassword := PasswordValue;
end;

{ ********************************************************** }
procedure TALHTTPClient.Execute(aRequestDataStream: TStream;
  aResponseContentStream: TStream;
  aResponseContentHeader: TALHTTPResponseHeader);
begin
  // virtual;
end;

{ ************************************************* }
procedure TALHTTPClient.Get(const aUrl: AnsiString;
  aResponseContentStream: TStream;
  aResponseContentHeader: TALHTTPResponseHeader);
begin
  URL := aUrl;
  RequestMethod := HTTPmt_Get;
  Execute(nil, aResponseContentStream, aResponseContentHeader);
end;

{ ************************************************** }
procedure TALHTTPClient.Post(const aUrl: AnsiString; aPostDataStream: TStream;
  aResponseContentStream: TStream;
  aResponseContentHeader: TALHTTPResponseHeader);
Var
  OldContentLengthValue: AnsiString;
begin
  URL := aUrl;
  RequestMethod := HTTPmt_Post;
  OldContentLengthValue := FRequestHeader.ContentLength;
  try
    If assigned(aPostDataStream) then
      FRequestHeader.ContentLength := ALIntToStr(aPostDataStream.Size)
    else
      FRequestHeader.ContentLength := '0';
    Execute(aPostDataStream, aResponseContentStream, aResponseContentHeader);
  finally
    FRequestHeader.ContentLength := OldContentLengthValue;
  end;
end;

{ ************************************************** }
procedure TALHTTPClient.Post(const aUrl: AnsiString;
  aResponseContentStream: TStream;
  aResponseContentHeader: TALHTTPResponseHeader);
begin
  Post(aUrl, nil, aResponseContentStream, aResponseContentHeader);
end;

{ ******************************************************************* }
procedure TALHTTPClient.PostMultipartFormData(const aUrl: AnsiString;
  aPostDataStrings: TALStrings; aPostDataFiles: TALMultiPartFormDataContents;
  aResponseContentStream: TStream;
  aResponseContentHeader: TALHTTPResponseHeader);
Var
  aMultipartFormDataEncoder: TALMultipartFormDataEncoder;
  OldRequestContentType: AnsiString;
begin
  aMultipartFormDataEncoder := TALMultipartFormDataEncoder.Create;
  OldRequestContentType := FRequestHeader.ContentType;
  try
    aMultipartFormDataEncoder.Encode(aPostDataStrings, aPostDataFiles);
    FRequestHeader.ContentType := 'multipart/form-data; boundary=' +
      aMultipartFormDataEncoder.DataStream.Boundary;
    Post(aUrl, aMultipartFormDataEncoder.DataStream, aResponseContentStream,
      aResponseContentHeader);
  finally
    aMultipartFormDataEncoder.free;
    FRequestHeader.ContentType := OldRequestContentType;
  end;
end;

{ ************************************************************ }
procedure TALHTTPClient.PostUrlEncoded(const aUrl: AnsiString;
  aPostDataStrings: TALStrings; aResponseContentStream: TStream;
  aResponseContentHeader: TALHTTPResponseHeader;
  Const EncodeParams: Boolean = True);
Var
  aURLEncodedContentStream: TALStringStream;
  OldRequestContentType: AnsiString;
  Str: AnsiString;
  i, P: Integer;
begin
  aURLEncodedContentStream := TALStringStream.Create('');
  OldRequestContentType := FRequestHeader.ContentType;
  try

    if EncodeParams then
    begin
      for i := 0 to aPostDataStrings.Count - 1 do
      begin
        Str := aPostDataStrings[i];
        P := AlPos(aPostDataStrings.NameValueSeparator, Str);
        if P > 0 then
          {$IF CompilerVersion >= 28}
          Str := AnsiString(TNetEncoding.URL.Encode(String(AlCopyStr(Str, 1, P - 1))) + '=' +
            TNetEncoding.URL.Encode(String(AlCopyStr(Str, P + 1, MaxInt))))
          {$ELSE}
          Str := HTTPEncode(AlCopyStr(Str, 1, P - 1)) + '=' +
            HTTPEncode(AlCopyStr(Str, P + 1, MaxInt))
          {$IFEND}

        else
          {$IF CompilerVersion >= 28}
          Str := AnsiString(TNetEncoding.URL.Encode(String(Str)));
          {$ELSE}
          Str := HTTPEncode(Str);
          {$IFEND}
        If i < aPostDataStrings.Count - 1 then
          aURLEncodedContentStream.WriteString(Str + '&')
        else
          aURLEncodedContentStream.WriteString(Str);
      end;
    end
    else
    begin
      for i := 0 to aPostDataStrings.Count - 1 do
      begin
        If i < aPostDataStrings.Count - 1 then
          aURLEncodedContentStream.WriteString(aPostDataStrings[i] + '&')
        else
          aURLEncodedContentStream.WriteString(aPostDataStrings[i]);
      end;
    end;

    FRequestHeader.ContentType := 'application/x-www-form-urlencoded';
    Post(aUrl, aURLEncodedContentStream, aResponseContentStream,
      aResponseContentHeader);
  finally
    aURLEncodedContentStream.free;
    FRequestHeader.ContentType := OldRequestContentType;
  end;
end;

{ ************************************************** }
procedure TALHTTPClient.Head(const aUrl: AnsiString;
  aResponseContentStream: TStream;
  aResponseContentHeader: TALHTTPResponseHeader);
begin
  URL := aUrl;
  RequestMethod := HTTPmt_Head;
  Execute(nil, aResponseContentStream, aResponseContentHeader);
end;

{ *************************************************** }
procedure TALHTTPClient.Trace(const aUrl: AnsiString;
  aResponseContentStream: TStream;
  aResponseContentHeader: TALHTTPResponseHeader);
begin
  URL := aUrl;
  RequestMethod := HTTPmt_Trace;
  Execute(nil, aResponseContentStream, aResponseContentHeader);
end;

{ ************************************************ }
procedure TALHTTPClient.Put(const aUrl: AnsiString; aPutDataStream: TStream;
  aResponseContentStream: TStream;
  aResponseContentHeader: TALHTTPResponseHeader);
Var
  OldContentLengthValue: AnsiString;
begin
  URL := aUrl;
  RequestMethod := HTTPmt_Put;
  OldContentLengthValue := FRequestHeader.ContentLength;
  try
    If assigned(aPutDataStream) then
      FRequestHeader.ContentLength := ALIntToStr(aPutDataStream.Size)
    else
      FRequestHeader.ContentLength := '0';
    Execute(aPutDataStream, aResponseContentStream, aResponseContentHeader);
  finally
    FRequestHeader.ContentLength := OldContentLengthValue;
  end;
end;

{ **************************************************** }
procedure TALHTTPClient.Delete(const aUrl: AnsiString;
  aResponseContentStream: TStream;
  aResponseContentHeader: TALHTTPResponseHeader);
begin
  URL := aUrl;
  RequestMethod := HTTPmt_Delete;
  Execute(nil, aResponseContentStream, aResponseContentHeader);
end;

{ ************************************************************* }
function TALHTTPClient.Get(const aUrl: AnsiString): AnsiString;
var
  aResponseContentStream: TALStringStream;
begin
  aResponseContentStream := TALStringStream.Create('');
  try
    Get(aUrl, aResponseContentStream, nil);
    Result := aResponseContentStream.DataString;
  finally
    aResponseContentStream.free;
  end;
end;

{ ************************************************ }
Procedure TALHTTPClient.Get(const aUrl: AnsiString; aParams: TALStrings;
  aResponseContentStream: TStream;
  aResponseContentHeader: TALHTTPResponseHeader;
  Const EncodeParams: Boolean = True);
Var
  Query: AnsiString;
  Str: AnsiString;
  i, P: Integer;
begin

  Query := '';
  for i := 0 to aParams.Count - 1 do
  begin
    Str := aParams[i];
    P := AlPos(aParams.NameValueSeparator, Str);
    if EncodeParams then
    begin
      {$IF CompilerVersion >= 28}
      if P > 0 then
        Query := Query + AnsiString(TNetEncoding.URL.Encode(String(AlCopyStr(Str, 1, P - 1))) + '=' +
          TNetEncoding.URL.Encode(String(AlCopyStr(Str, P + 1, MaxInt)))) +
          ALIfThen(i < aParams.Count - 1, '&')
      else
        Query := Query + AnsiString(TNetEncoding.URL.Encode(String(Str))) + ALIfThen(i < aParams.Count - 1, '&')
      {$ELSE}
      if P > 0 then
        Query := Query + HTTPEncode(AlCopyStr(Str, 1, P - 1)) + '=' +
          HTTPEncode(AlCopyStr(Str, P + 1, MaxInt)) +
          ALIfThen(i < aParams.Count - 1, '&')
      else
        Query := Query + HTTPEncode(Str) + ALIfThen(i < aParams.Count - 1, '&')
      {$IFEND}
    end
    else
    begin
      if P > 0 then
        Query := Query + AlCopyStr(Str, 1, P - 1) + '=' +
          AlCopyStr(Str, P + 1, MaxInt) + ALIfThen(i < aParams.Count - 1, '&')
      else
        Query := Query + Str + ALIfThen(i < aParams.Count - 1, '&')
    end;
  end;
  if Query <> '' then
  begin
    P := AlPos('?', aUrl);
    if P <= 0 then
      Query := '?' + Query
    else if P <> Length(aUrl) then
      Query := '&' + Query;
  end;

  Get(aUrl + Query, aResponseContentStream, aResponseContentHeader);

end;

{ *********************************************** }
Function TALHTTPClient.Get(const aUrl: AnsiString; aParams: TALStrings;
  Const EncodeParams: Boolean = True): AnsiString;
var
  aResponseContentStream: TALStringStream;
begin
  aResponseContentStream := TALStringStream.Create('');
  try
    Get(aUrl, aParams, aResponseContentStream, nil, EncodeParams);
    Result := aResponseContentStream.DataString;
  finally
    aResponseContentStream.free;
  end;
end;

{ **************************************************************************************** }
function TALHTTPClient.Post(const aUrl: AnsiString; aPostDataStream: TStream)
  : AnsiString;
var
  aResponseContentStream: TALStringStream;
begin
  aResponseContentStream := TALStringStream.Create('');
  try
    Post(aUrl, aPostDataStream, aResponseContentStream, nil);
    Result := aResponseContentStream.DataString;
  finally
    aResponseContentStream.free;
  end;
end;

{ ************************************************************** }
function TALHTTPClient.Post(const aUrl: AnsiString): AnsiString;
begin
  Result := Post(aUrl, nil);
end;

{ ****************************************************************** }
function TALHTTPClient.PostMultipartFormData(const aUrl: AnsiString;
  aPostDataStrings: TALStrings; aPostDataFiles: TALMultiPartFormDataContents)
  : AnsiString;
Var
  aMultipartFormDataEncoder: TALMultipartFormDataEncoder;
  OldRequestContentType: AnsiString;
begin
  aMultipartFormDataEncoder := TALMultipartFormDataEncoder.Create;
  OldRequestContentType := FRequestHeader.ContentType;
  try
    aMultipartFormDataEncoder.Encode(aPostDataStrings, aPostDataFiles);
    FRequestHeader.ContentType := 'multipart/form-data; boundary=' +
      aMultipartFormDataEncoder.DataStream.Boundary;
    Result := Post(aUrl, aMultipartFormDataEncoder.DataStream);
  finally
    aMultipartFormDataEncoder.free;
    FRequestHeader.ContentType := OldRequestContentType;
  end;
end;

{ *********************************************************** }
function TALHTTPClient.PostUrlEncoded(const aUrl: AnsiString;
  aPostDataStrings: TALStrings; Const EncodeParams: Boolean = True): AnsiString;
Var
  aURLEncodedContentStream: TALStringStream;
  OldRequestContentType: AnsiString;
  Str: AnsiString;
  i, P: Integer;
begin
  aURLEncodedContentStream := TALStringStream.Create('');
  OldRequestContentType := FRequestHeader.ContentType;
  try

    if EncodeParams then
    begin
      for i := 0 to aPostDataStrings.Count - 1 do
      begin
        Str := aPostDataStrings[i];
        P := AlPos(aPostDataStrings.NameValueSeparator, Str);

        {$IF CompilerVersion >= 28}
        if P > 0 then
          Str := AnsiString(TNetEncoding.URL.Encode(String(AlCopyStr(Str, 1, P - 1))) + '=' +
            TNetEncoding.URL.Encode(String(AlCopyStr(Str, P + 1, MaxInt))))
        else
          Str := AnsiString(TNetEncoding.URL.Encode(String(Str)));
        {$ELSE}
        if P > 0 then
          Str := HTTPEncode(AlCopyStr(Str, 1, P - 1)) + '=' +
            HTTPEncode(AlCopyStr(Str, P + 1, MaxInt))
        else
          Str := HTTPEncode(Str);
        {$IFEND}

        if i < aPostDataStrings.Count - 1 then
          aURLEncodedContentStream.WriteString(Str + '&')
        else
          aURLEncodedContentStream.WriteString(Str);
      end;
    end
    else
    begin
      for i := 0 to aPostDataStrings.Count - 1 do
      begin
        If i < aPostDataStrings.Count - 1 then
          aURLEncodedContentStream.WriteString(aPostDataStrings[i] + '&')
        else
          aURLEncodedContentStream.WriteString(aPostDataStrings[i]);
      end;
    end;

    FRequestHeader.ContentType := 'application/x-www-form-urlencoded';
    Result := Post(aUrl, aURLEncodedContentStream);
  finally
    aURLEncodedContentStream.free;
    FRequestHeader.ContentType := OldRequestContentType;
  end;
end;

{ ************************************************************** }
function TALHTTPClient.Head(const aUrl: AnsiString): AnsiString;
var
  aResponseContentStream: TALStringStream;
begin
  aResponseContentStream := TALStringStream.Create('');
  try
    Head(aUrl, aResponseContentStream, nil);
    Result := aResponseContentStream.DataString;
  finally
    aResponseContentStream.free;
  end;
end;

{ ************************************************************** }
function TALHTTPClient.Trace(const aUrl: AnsiString): AnsiString;
var
  aResponseContentStream: TALStringStream;
begin
  aResponseContentStream := TALStringStream.Create('');
  try
    Trace(aUrl, aResponseContentStream, nil);
    Result := aResponseContentStream.DataString;
  finally
    aResponseContentStream.free;
  end;
end;

{ ************************************************************************************** }
function TALHTTPClient.Put(const aUrl: AnsiString; aPutDataStream: TStream)
  : AnsiString;
var
  aResponseContentStream: TALStringStream;
begin
  aResponseContentStream := TALStringStream.Create('');
  try
    Put(aUrl, aPutDataStream, aResponseContentStream, nil);
    Result := aResponseContentStream.DataString;
  finally
    aResponseContentStream.free;
  end;
end;

{ **************************************************************** }
function TALHTTPClient.Delete(const aUrl: AnsiString): AnsiString;
var
  aResponseContentStream: TALStringStream;
begin
  aResponseContentStream := TALStringStream.Create('');
  try
    Delete(aUrl, aResponseContentStream, nil);
    Result := aResponseContentStream.DataString;
  finally
    aResponseContentStream.free;
  end;
end;

{ ***************************************************************************************** }
procedure TALHTTPClient.OnProxyParamsChange(sender: Tobject;
  Const PropertyIndex: Integer);
begin
  // virtual
end;

{ ******************************************************************************************* }
procedure TALHTTPClient.OnRequestHeaderChange(sender: Tobject;
  Const PropertyIndex: Integer);
begin
  // virtual
end;

{ **************************************************************** }
procedure TALHTTPClient.SetUploadBufferSize(const Value: Integer);
begin
  If Value >= 0 then
    FUploadBufferSize := Value;
end;

{ *************************************** }
procedure TALHTTPClientProxyParams.Clear;
begin
  FProxyBypass := '';
  FproxyServer := '';
  FProxyUserName := '';
  FProxyPassword := '';
  FproxyPort := 0;
  DoChange(-1);
end;

{ ****************************************** }
constructor TALHTTPClientProxyParams.Create;
Begin
  inherited Create;
  FProxyBypass := '';
  FproxyServer := '';
  FProxyUserName := '';
  FProxyPassword := '';
  FproxyPort := 0;
  FOnChange := nil;
end;

{ ****************************************************************** }
procedure TALHTTPClientProxyParams.DoChange(PropertyIndex: Integer);
begin
  if assigned(FOnChange) then
    FOnChange(Self, PropertyIndex);
end;

{ ************************************************************************* }
procedure TALHTTPClientProxyParams.SetProxyBypass(const Value: AnsiString);
begin
  If (Value <> FProxyBypass) then
  begin
    FProxyBypass := Value;
    DoChange(0);
  end;
end;

{ *************************************************************************** }
procedure TALHTTPClientProxyParams.SetProxyPassword(const Value: AnsiString);
begin
  If (Value <> FProxyPassword) then
  begin
    FProxyPassword := Value;
    DoChange(4);
  end;
end;

{ ******************************************************************** }
procedure TALHTTPClientProxyParams.SetProxyPort(const Value: Integer);
begin
  If (Value <> FproxyPort) then
  begin
    FproxyPort := Value;
    DoChange(2);
  end;
end;

{ ************************************************************************* }
procedure TALHTTPClientProxyParams.SetProxyServer(const Value: AnsiString);
begin
  If (Value <> FproxyServer) then
  begin
    FproxyServer := Value;
    DoChange(1);
  end;
end;

{ *************************************************************************** }
procedure TALHTTPClientProxyParams.SetProxyUserName(const Value: AnsiString);
begin
  If (Value <> FProxyUserName) then
  begin
    FProxyUserName := Value;
    DoChange(3);
  end;
end;

end.
