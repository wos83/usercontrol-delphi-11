{ *************************************************************
  www:          http://sourceforge.net/projects/alcinoe/
  svn:          svn checkout svn://svn.code.sf.net/p/alcinoe/code/ alcinoe-code
  Author(s):    St?phane Vander Clock (alcinoe@arkadia.com)
  Sponsor(s):   Arkadia SA (http://www.arkadia.com)

  product:      ALWebSpider
  Version:      4.00

  Description:  The function in this unit allows you to download a
  World Wide Web site from the Internet to a local directory,
  building recursively all directories, getting HTML, images,
  and other files from the server to your computer. The functions
  arranges the original site's relative link-structure. Simply
  open a page of the "mirrored" website in your browser, and you
  can browse the site from link to link, as if you were viewing it
  online.

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

  Know bug :    Link like :
  <td><img src="/imgmix/situation.php?dept=Corse du Sud&coordx=1149.00&coordy=1657.60&t=1133520053 width="200" height="200" border="0"></td>
  Will be not handle corretly because one " is missed.
  it's not an valide HTML document but unfortunatly ie work correctly
  with this kind of error... mean that webmaster can make this error
  without seeing it ! so we need to find a way to handle this error

  History :     27/10/2005: Replace LstPageDownloaded and LstPageleft
  TstringList by binary tree for better performance
  when crawl huge site with more than 100.000 Url
  16/11/2005: Few improuvement;
  28/11/2005: Move procedure to Component;
  10/09/2007: Move ALCompactHtmlTagParams in ALFcnHTML
  26/06/2012: Add xe2 support

  Link :

  * Please send all your feedback to alcinoe@arkadia.com
  * If you have downloaded this source from a website different from
  sourceforge.net, please get the last version on http://sourceforge.net/projects/alcinoe/
  * Please, help us to keep the development of these components free by
  promoting the sponsor on http://static.arkadia.com/html/alcinoe_like.html
  ************************************************************** }
unit ALWebSpider;

interface

{$IF CompilerVersion >= 25} { Delphi XE4 }
{$LEGACYIFEND ON} // http://docwiki.embarcadero.com/RADStudio/XE4/en/Legacy_IFEND_(Delphi)
{$IFEND}

Uses {$IF CompilerVersion >= 23} {Delphi XE2}
  System.classes,
{$ELSE}
  classes,
{$IFEND}
  AlAvlBinaryTree,
  AlHTTPClient,
  AlStringList;

Type

  { ----------------------------------------------------------------- }
  TAlWebSpiderCrawlDownloadSuccessEvent = procedure(Sender: TObject;
    Url: AnsiString; HTTPResponseHeader: TALHTTPResponseHeader;
    HttpResponseContent: TStream; Var StopCrawling: Boolean) of object;

  { ------------------------------------------------------------------ }
  TAlWebSpiderCrawlDownloadRedirectEvent = procedure(Sender: TObject;
    Url: AnsiString; RedirectedTo: AnsiString;
    HTTPResponseHeader: TALHTTPResponseHeader; Var StopCrawling: Boolean)
    of object;

  { --------------------------------------------------------------- }
  TAlWebSpiderCrawlDownloadErrorEvent = procedure(Sender: TObject;
    Url: AnsiString; ErrorMessage: AnsiString;
    HTTPResponseHeader: TALHTTPResponseHeader; Var StopCrawling: Boolean)
    of object;

  { ------------------------------------------------------------- }
  TAlWebSpiderCrawlGetNextLinkEvent = procedure(Sender: TObject;
    Var Url: AnsiString) of object;

  { ---------------------------------------------------------- }
  TAlWebSpiderCrawlFindLinkEvent = Procedure(Sender: TObject;
    HtmlTagString: AnsiString; HtmlTagParams: TALStrings; Url: AnsiString)
    of object;

  { ---------------------------------------------------------------- }
  TAlWebSpiderCrawlEndEvent = Procedure(Sender: TObject) of object;

  { -------------------------------------------------------------------------------------------- }
  TAlWebSpiderCrawlBeforeDownloadEvent = Procedure(Sender: TObject;
    Url: AnsiString) of object;

  { --------------------------------------------------------------- }
  TAlWebSpiderCrawlAfterDownloadEvent = Procedure(Sender: TObject;
    Url: AnsiString; HTTPResponseHeader: TALHTTPResponseHeader;
    HttpResponseContent: TStream; Var StopCrawling: Boolean) of object;

  { ----------------------------------------------------------------------------- }
  TAlWebSpiderUpdateLinkToLocalPathGetNextFileEvent = procedure(Sender: TObject;
    Var FileName: AnsiString; Var BaseHref: AnsiString) of object;

  { -------------------------------------------------------------------------- }
  TAlWebSpiderUpdateLinkToLocalPathFindLinkEvent = Procedure(Sender: TObject;
    HtmlTagString: AnsiString; HtmlTagParams: TALStrings; Url: AnsiString;
    Var LocalPath: AnsiString) of object;

  { -------------------------------------------------------------------------------- }
  TAlWebSpiderUpdateLinkToLocalPathEndEvent = Procedure(Sender: TObject)
    of object;

  { --------------------------- }
  TAlWebSpider = Class(TObject)
  Private
    fOnUpdateLinkToLocalPathEnd: TAlWebSpiderUpdateLinkToLocalPathEndEvent;
    fOnUpdateLinkToLocalPathFindLink
      : TAlWebSpiderUpdateLinkToLocalPathFindLinkEvent;
    fOnUpdateLinkToLocalPathGetNextFile
      : TAlWebSpiderUpdateLinkToLocalPathGetNextFileEvent;
    fOnCrawlDownloadError: TAlWebSpiderCrawlDownloadErrorEvent;
    fOnCrawlDownloadRedirect: TAlWebSpiderCrawlDownloadRedirectEvent;
    fOnCrawlDownloadSuccess: TAlWebSpiderCrawlDownloadSuccessEvent;
    FOnCrawlFindLink: TAlWebSpiderCrawlFindLinkEvent;
    fOnCrawlGetNextLink: TAlWebSpiderCrawlGetNextLinkEvent;
    FOnCrawlEnd: TAlWebSpiderCrawlEndEvent;
    FHttpClient: TalHttpClient;
    fOnCrawlBeforeDownload: TAlWebSpiderCrawlBeforeDownloadEvent;
    fOnCrawlAfterDownload: TAlWebSpiderCrawlAfterDownloadEvent;
  Public
    Procedure Crawl; { Launch the Crawling of the page }
    Procedure UpdateLinkToLocalPath;
    { Update the link of downloaded page to local path }
    Property OnCrawlBeforeDownload: TAlWebSpiderCrawlBeforeDownloadEvent
      read fOnCrawlBeforeDownload write fOnCrawlBeforeDownload;
    { When a page is successfully downloaded }
    Property OnCrawlAfterDownload: TAlWebSpiderCrawlAfterDownloadEvent
      read fOnCrawlAfterDownload write fOnCrawlAfterDownload;
    { When a page is successfully downloaded }
    Property OnCrawlDownloadSuccess: TAlWebSpiderCrawlDownloadSuccessEvent
      read fOnCrawlDownloadSuccess write fOnCrawlDownloadSuccess;
    { When a page is successfully downloaded }
    Property OnCrawlDownloadRedirect: TAlWebSpiderCrawlDownloadRedirectEvent
      read fOnCrawlDownloadRedirect write fOnCrawlDownloadRedirect;
    { When a page is redirected }
    Property OnCrawlDownloadError: TAlWebSpiderCrawlDownloadErrorEvent
      read fOnCrawlDownloadError write fOnCrawlDownloadError;
    { When the download of a page encounter an error }
    Property OnCrawlGetNextLink: TAlWebSpiderCrawlGetNextLinkEvent
      read fOnCrawlGetNextLink Write fOnCrawlGetNextLink;
    { When we need another url to download }
    Property OnCrawlFindLink: TAlWebSpiderCrawlFindLinkEvent
      read FOnCrawlFindLink Write FOnCrawlFindLink;
    { When we find a link in url just downloaded }
    Property OnCrawlEnd: TAlWebSpiderCrawlEndEvent read FOnCrawlEnd
      write FOnCrawlEnd; { When their is no more url to crawl }
    Property OnUpdateLinkToLocalPathGetNextFile
      : TAlWebSpiderUpdateLinkToLocalPathGetNextFileEvent
      read fOnUpdateLinkToLocalPathGetNextFile
      write fOnUpdateLinkToLocalPathGetNextFile;
    { When we need another file to update link to local path }
    property OnUpdateLinkToLocalPathFindLink
      : TAlWebSpiderUpdateLinkToLocalPathFindLinkEvent
      read fOnUpdateLinkToLocalPathFindLink
      write fOnUpdateLinkToLocalPathFindLink;
    { When we find a link and we need the local path for the file }
    property OnUpdateLinkToLocalPathEnd
      : TAlWebSpiderUpdateLinkToLocalPathEndEvent
      read fOnUpdateLinkToLocalPathEnd write fOnUpdateLinkToLocalPathEnd;
    { When their is no more local file to update link }
    Property HttpClient: TalHttpClient Read FHttpClient write FHttpClient;
    { http client use to crawl the web }
  end;

  { ------------------------------------------------------------------------------------------------------------------------------------------- }
  TAlTrivialWebSpiderCrawlProgressEvent = Procedure(Sender: TObject;
    UrltoDownload, UrlDownloaded: Integer; CurrentUrl: AnsiString) of object;

  { ------------------------------------------------------------------------------------------------------------------- }
  TAlTrivialWebSpiderUpdateLinkToLocalPathProgressEvent = Procedure
    (Sender: TObject; aFileName: AnsiString) of object;

  { ----------------------------------------------------------------- }
  TAlTrivialWebSpiderCrawlFindLinkEvent = Procedure(Sender: TObject;
    HtmlTagString: AnsiString; HtmlTagParams: TALStrings; Url: AnsiString;
    Var Ignore: Boolean) of object;

  { ---------------------------------- }
  TAlTrivialWebSpider = Class(TObject)
  Private
    FWebSpider: TAlWebSpider;
    fStartUrl: AnsiString;
    fLstUrlCrawled: TALStrings;
    fLstErrorEncountered: TALStrings;
    FPageDownloadedBinTree: TAlStringKeyAVLBinaryTree;
    FPageNotYetDownloadedBinTree: TAlStringKeyAVLBinaryTree;
    FCurrentDeepLevel: Integer;
    FCurrentLocalFileNameIndex: Integer;
    fMaxDeepLevel: Integer;
    fOnCrawlBeforeDownload: TAlWebSpiderCrawlBeforeDownloadEvent;
    fUpdateLinkToLocalPath: Boolean;
    fExcludeMask: AnsiString;
    fStayInStartDomain: Boolean;
    fSaveDirectory: AnsiString;
    fSplitDirectoryAmount: Integer;
    FHttpClient: TalHttpClient;
    fIncludeMask: AnsiString;
    fOnCrawlAfterDownload: TAlWebSpiderCrawlAfterDownloadEvent;
    FOnCrawlFindLink: TAlTrivialWebSpiderCrawlFindLinkEvent;
    fDownloadImage: Boolean;
    fOnUpdateLinkToLocalPathProgress
      : TAlTrivialWebSpiderUpdateLinkToLocalPathProgressEvent;
    fOnCrawlProgress: TAlTrivialWebSpiderCrawlProgressEvent;
    procedure WebSpiderCrawlDownloadError(Sender: TObject;
      Url, ErrorMessage: AnsiString; HTTPResponseHeader: TALHTTPResponseHeader;
      var StopCrawling: Boolean);
    procedure WebSpiderCrawlDownloadRedirect(Sender: TObject;
      Url, RedirectedTo: AnsiString; HTTPResponseHeader: TALHTTPResponseHeader;
      var StopCrawling: Boolean);
    procedure WebSpiderCrawlDownloadSuccess(Sender: TObject; Url: AnsiString;
      HTTPResponseHeader: TALHTTPResponseHeader; HttpResponseContent: TStream;
      var StopCrawling: Boolean);
    procedure WebSpiderCrawlFindLink(Sender: TObject; HtmlTagString: AnsiString;
      HtmlTagParams: TALStrings; Url: AnsiString);
    procedure WebSpiderCrawlGetNextLink(Sender: TObject; var Url: AnsiString);
    procedure WebSpiderUpdateLinkToLocalPathFindLink(Sender: TObject;
      HtmlTagString: AnsiString; HtmlTagParams: TALStrings; Url: AnsiString;
      var LocalPath: AnsiString);
    procedure WebSpiderUpdateLinkToLocalPathGetNextFile(Sender: TObject;
      var FileName, BaseHref: AnsiString);
    function GetNextLocalFileName(aContentType: AnsiString): AnsiString;
  Protected
  Public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Crawl(aUrl: AnsiString); overload;
    { Launch the Crawling of the page }
    procedure Crawl(aUrl: AnsiString; LstUrlCrawled: TALStrings;
      LstErrorEncountered: TALStrings); overload;
    Property HttpClient: TalHttpClient Read FHttpClient write FHttpClient;
    Property DownloadImage: Boolean read fDownloadImage write fDownloadImage
      default false;
    Property StayInStartDomain: Boolean read fStayInStartDomain
      write fStayInStartDomain default true;
    Property UpdateLinkToLocalPath: Boolean read fUpdateLinkToLocalPath
      write fUpdateLinkToLocalPath default true;
    Property MaxDeepLevel: Integer read fMaxDeepLevel write fMaxDeepLevel
      default -1;
    Property ExcludeMask: AnsiString read fExcludeMask write fExcludeMask;
    Property IncludeMask: AnsiString read fIncludeMask write fIncludeMask;
    Property SaveDirectory: AnsiString read fSaveDirectory write fSaveDirectory;
    Property SplitDirectoryAmount: Integer read fSplitDirectoryAmount
      write fSplitDirectoryAmount default 5000;
    Property OnCrawlBeforeDownload: TAlWebSpiderCrawlBeforeDownloadEvent
      read fOnCrawlBeforeDownload write fOnCrawlBeforeDownload;
    { When a page is successfully downloaded }
    Property OnCrawlAfterDownload: TAlWebSpiderCrawlAfterDownloadEvent
      read fOnCrawlAfterDownload write fOnCrawlAfterDownload;
    { When a page is successfully downloaded }
    Property OnCrawlFindLink: TAlTrivialWebSpiderCrawlFindLinkEvent
      read FOnCrawlFindLink write FOnCrawlFindLink; { When a a link is found }
    Property OnCrawlProgress: TAlTrivialWebSpiderCrawlProgressEvent
      read fOnCrawlProgress write fOnCrawlProgress;
    Property OnUpdateLinkToLocalPathProgress
      : TAlTrivialWebSpiderUpdateLinkToLocalPathProgressEvent
      read fOnUpdateLinkToLocalPathProgress
      write fOnUpdateLinkToLocalPathProgress;
  end;

  { ---------------------------------------------------------------------------------- }
  TAlTrivialWebSpider_PageDownloadedBinTreeNode = Class
    (TALStringKeyAVLBinaryTreeNode)
  Private
  Protected
  Public
    Data: AnsiString;
  end;

  { ---------------------------------------------------------------------------------------- }
  TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode = Class
    (TALStringKeyAVLBinaryTreeNode)
  Private
  Protected
  Public
    DeepLevel: Integer;
  end;

implementation

Uses {$IF CompilerVersion >= 23} {Delphi XE2}
  Winapi.Windows,
  System.sysutils,
  Winapi.WinInet,
  Winapi.UrlMon,
{$ELSE}
  Windows,
  sysutils,
  WinInet,
  UrlMon,
{$IFEND}
  AlHTML,
  AlMime,
  ALString;

type

  { ***************************************** }
  _TAlWebSpiderHandleTagfunctExtData = record
    WebSpiderObj: TAlWebSpider;
    CurrentBaseHref: AnsiString;
  end;

  { ************************************************************************ }
Function _AlWebSpiderExtractUrlHandleTagfunct(const TagString: AnsiString;
  TagParams: TALStrings; ExtData: pointer; Var Handled: Boolean): AnsiString;

{ --------------------------------------------- }
  Procedure FindUrl(aUrl, aBaseHref: AnsiString);
  Begin
    { do not work with anchor in self document }
    If (aUrl <> '') and (AlPos('#', aUrl) <> 1) then
    begin

      { make url full path }
      aUrl := AlCombineUrl(aUrl, aBaseHref);

      { exit if it's not a http sheme }
      IF (AlExtractShemeFromUrl(aUrl) in [INTERNET_SCHEME_HTTP,
        INTERNET_SCHEME_HTTPS]) then

        { fire findlink Event }
        with _TAlWebSpiderHandleTagfunctExtData(ExtData^) do
          WebSpiderObj.FOnCrawlFindLink(WebSpiderObj, TagString,
            TagParams, aUrl);
    end;
  end;

Var
  Str: AnsiString;
  LowerTagString: AnsiString;
begin
  Handled := false;
  Result := '';
  ALCompactHtmlTagParams(TagParams);
  LowerTagString := AlLowerCase(TagString);

  with _TAlWebSpiderHandleTagfunctExtData(ExtData^) do
  begin

    If LowerTagString = 'a' then
      FindUrl(ALTrim(TagParams.Values['href']), CurrentBaseHref)
    else If LowerTagString = 'applet' then
    Begin
      Str := ALTrim(TagParams.Values['codebase']);
      // The CODEBASE parameter specifies where the jar and cab files are located.
      { make str full path }
      If Str <> '' then
        Str := AlCombineUrl(Str, CurrentBaseHref)
      else
        Str := CurrentBaseHref;
      FindUrl(ALTrim(TagParams.Values['code']), Str);
      // The URL specified by code might be relative to the codebase attribute.
      FindUrl(ALTrim(TagParams.Values['archive']), Str);
      // The URL specified by code might be relative to the codebase attribute.
    end
    else if LowerTagString = 'area' then
      FindUrl(ALTrim(TagParams.Values['href']), CurrentBaseHref)
    else if LowerTagString = 'bgsound' then
      FindUrl(ALTrim(TagParams.Values['src']), CurrentBaseHref)
    else if LowerTagString = 'blockquote' then
      FindUrl(ALTrim(TagParams.Values['cite']), CurrentBaseHref)
    else if LowerTagString = 'body' then
      FindUrl(ALTrim(TagParams.Values['background']), CurrentBaseHref)
    else if LowerTagString = 'del' then
      FindUrl(ALTrim(TagParams.Values['cite']), CurrentBaseHref)
    else if LowerTagString = 'embed' then
      FindUrl(ALTrim(TagParams.Values['src']), CurrentBaseHref)
    else if LowerTagString = 'frame' then
    begin
      FindUrl(ALTrim(TagParams.Values['longdesc']), CurrentBaseHref);
      FindUrl(ALTrim(TagParams.Values['src']), CurrentBaseHref);
    end
    else if LowerTagString = 'head' then
      FindUrl(ALTrim(TagParams.Values['profile']), CurrentBaseHref)
    else if LowerTagString = 'iframe' then
    begin
      FindUrl(ALTrim(TagParams.Values['longdesc']), CurrentBaseHref);
      FindUrl(ALTrim(TagParams.Values['src']), CurrentBaseHref);
    end
    else if LowerTagString = 'ilayer' then
    begin
      FindUrl(ALTrim(TagParams.Values['background']), CurrentBaseHref);
      FindUrl(ALTrim(TagParams.Values['src']), CurrentBaseHref);
    end
    else If LowerTagString = 'img' then
    Begin
      FindUrl(ALTrim(TagParams.Values['longdesc']), CurrentBaseHref);
      FindUrl(ALTrim(TagParams.Values['src']), CurrentBaseHref);
      FindUrl(ALTrim(TagParams.Values['usemap']), CurrentBaseHref);
      FindUrl(ALTrim(TagParams.Values['dynsrc']), CurrentBaseHref);
      FindUrl(ALTrim(TagParams.Values['lowsrc']), CurrentBaseHref);
    end
    else if LowerTagString = 'input' then
    begin
      FindUrl(ALTrim(TagParams.Values['src']), CurrentBaseHref);
      FindUrl(ALTrim(TagParams.Values['usemap']), CurrentBaseHref);
      FindUrl(ALTrim(TagParams.Values['dynsrc']), CurrentBaseHref);
      FindUrl(ALTrim(TagParams.Values['lowsrc']), CurrentBaseHref);
    end
    else if LowerTagString = 'ins' then
      FindUrl(ALTrim(TagParams.Values['cite']), CurrentBaseHref)
    else if LowerTagString = 'layer' then
    begin
      FindUrl(ALTrim(TagParams.Values['background']), CurrentBaseHref);
      FindUrl(ALTrim(TagParams.Values['src']), CurrentBaseHref);
    end
    else if LowerTagString = 'link' then
      FindUrl(ALTrim(TagParams.Values['href']), CurrentBaseHref)
    else If LowerTagString = 'object' then
    Begin
      Str := ALTrim(TagParams.Values['codebase']);
      // The CODEBASE parameter specifies where the jar and cab files are located.
      { make str full path }
      If Str <> '' then
        Str := AlCombineUrl(Str, CurrentBaseHref)
      else
        Str := CurrentBaseHref;
      FindUrl(ALTrim(TagParams.Values['classid']), Str);
      // The URL specified by code might be relative to the codebase attribute.
      FindUrl(ALTrim(TagParams.Values['data']), Str);
      // The URL specified by code might be relative to the codebase attribute.
      FindUrl(ALTrim(TagParams.Values['archive']), Str);
      // The URL specified by code might be relative to the codebase attribute.
      FindUrl(ALTrim(TagParams.Values['usemap']), CurrentBaseHref);
    end
    else if LowerTagString = 'q' then
      FindUrl(ALTrim(TagParams.Values['cite']), CurrentBaseHref)
    else if LowerTagString = 'script' then
      FindUrl(ALTrim(TagParams.Values['src']), CurrentBaseHref)
    else if LowerTagString = 'table' then
      FindUrl(ALTrim(TagParams.Values['background']), CurrentBaseHref)
    else if LowerTagString = 'td' then
      FindUrl(ALTrim(TagParams.Values['background']), CurrentBaseHref)
    else if LowerTagString = 'th' then
      FindUrl(ALTrim(TagParams.Values['background']), CurrentBaseHref)
    else if LowerTagString = 'xml' then
      FindUrl(ALTrim(TagParams.Values['src']), CurrentBaseHref)
    else if LowerTagString = 'base' then
    Begin
      Str := ALTrim(TagParams.Values['href']);
      If Str <> '' then
        CurrentBaseHref := Str;
    end;

  end;
end;

{ *********************************************************************************** }
Function _AlWebSpiderUpdateLinkToLocalPathHandleTagfunct(const TagString
  : AnsiString; TagParams: TALStrings; ExtData: pointer; Var Handled: Boolean)
  : AnsiString;

{ --------------------------------------------------- }
  Procedure FindUrl(aParamName, aBaseHref: AnsiString);
  Var
    aUrl: AnsiString;
    aLocalPathValue: AnsiString;
  Begin
    { extract Url }
    aUrl := ALTrim(TagParams.Values[aParamName]);

    { do not work with anchor in self document }
    If (aUrl <> '') and (AlPos('#', aUrl) <> 1) then
    begin

      { make url full path }
      aUrl := AlCombineUrl(aUrl, aBaseHref);

      { exit if it's not a http sheme }
      IF (AlExtractShemeFromUrl(aUrl) in [INTERNET_SCHEME_HTTP,
        INTERNET_SCHEME_HTTPS]) then
      begin

        { init local path value }
        aLocalPathValue := '';

        { fire findlink Event }
        with _TAlWebSpiderHandleTagfunctExtData(ExtData^) do
          WebSpiderObj.fOnUpdateLinkToLocalPathFindLink(WebSpiderObj, TagString,
            TagParams, aUrl, aLocalPathValue);

        { update tagParams }
        If (aLocalPathValue <> '') then
        begin
          Handled := true;
          TagParams.Values[aParamName] := aLocalPathValue; // 1234.htm#foo
        end;
      end;
    end;
  end;

Var
  Str: AnsiString;
  LowerTagString: AnsiString;
  i: Integer;
begin
  Handled := false;
  Result := '';
  ALCompactHtmlTagParams(TagParams);
  LowerTagString := AlLowerCase(TagString);

  with _TAlWebSpiderHandleTagfunctExtData(ExtData^) do
  begin

    If LowerTagString = 'a' then
      FindUrl('href', CurrentBaseHref)
    else If LowerTagString = 'applet' then
    Begin
      Str := ALTrim(TagParams.Values['codebase']);
      // The CODEBASE parameter specifies where the jar and cab files are located.
      { make str full path }
      If Str <> '' then
        Str := AlCombineUrl(Str, CurrentBaseHref)
      else
        Str := CurrentBaseHref;
      FindUrl('code', Str);
      // The URL specified by code might be relative to the codebase attribute.
      FindUrl('archive', Str);
      // The URL specified by code might be relative to the codebase attribute.
    end
    else if LowerTagString = 'area' then
      FindUrl('href', CurrentBaseHref)
    else if LowerTagString = 'bgsound' then
      FindUrl('src', CurrentBaseHref)
    else if LowerTagString = 'blockquote' then
      FindUrl('cite', CurrentBaseHref)
    else if LowerTagString = 'body' then
      FindUrl('background', CurrentBaseHref)
    else if LowerTagString = 'del' then
      FindUrl('cite', CurrentBaseHref)
    else if LowerTagString = 'embed' then
      FindUrl('src', CurrentBaseHref)
    else if LowerTagString = 'frame' then
    begin
      FindUrl('longdesc', CurrentBaseHref);
      FindUrl('src', CurrentBaseHref);
    end
    else if LowerTagString = 'head' then
      FindUrl('profile', CurrentBaseHref)
    else if LowerTagString = 'iframe' then
    begin
      FindUrl('longdesc', CurrentBaseHref);
      FindUrl('src', CurrentBaseHref);
    end
    else if LowerTagString = 'ilayer' then
    begin
      FindUrl('background', CurrentBaseHref);
      FindUrl('src', CurrentBaseHref);
    end
    else If LowerTagString = 'img' then
    Begin
      FindUrl('longdesc', CurrentBaseHref);
      FindUrl('src', CurrentBaseHref);
      FindUrl('usemap', CurrentBaseHref);
      FindUrl('dynsrc', CurrentBaseHref);
      FindUrl('lowsrc', CurrentBaseHref);
    end
    else if LowerTagString = 'input' then
    begin
      FindUrl('src', CurrentBaseHref);
      FindUrl('usemap', CurrentBaseHref);
      FindUrl('dynsrc', CurrentBaseHref);
      FindUrl('lowsrc', CurrentBaseHref);
    end
    else if LowerTagString = 'ins' then
      FindUrl('cite', CurrentBaseHref)
    else if LowerTagString = 'layer' then
    begin
      FindUrl('background', CurrentBaseHref);
      FindUrl('src', CurrentBaseHref);
    end
    else if LowerTagString = 'link' then
      FindUrl('href', CurrentBaseHref)
    else If LowerTagString = 'object' then
    Begin
      Str := ALTrim(TagParams.Values['codebase']);
      // The CODEBASE parameter specifies where the jar and cab files are located.
      { make str full path }
      If Str <> '' then
        Str := AlCombineUrl(Str, CurrentBaseHref)
      else
        Str := CurrentBaseHref;
      FindUrl('classid', Str);
      // The URL specified by code might be relative to the codebase attribute.
      FindUrl('data', Str);
      // The URL specified by code might be relative to the codebase attribute.
      FindUrl('archive', Str);
      // The URL specified by code might be relative to the codebase attribute.
      FindUrl('usemap', CurrentBaseHref);
    end
    else if LowerTagString = 'q' then
      FindUrl('cite', CurrentBaseHref)
    else if LowerTagString = 'script' then
      FindUrl('src', CurrentBaseHref)
    else if LowerTagString = 'table' then
      FindUrl('background', CurrentBaseHref)
    else if LowerTagString = 'td' then
      FindUrl('background', CurrentBaseHref)
    else if LowerTagString = 'th' then
      FindUrl('background', CurrentBaseHref)
    else if LowerTagString = 'xml' then
      FindUrl('src', CurrentBaseHref)
    else if LowerTagString = 'base' then
    begin
      Handled := true;
      exit;
    end;

    { update the html source code }
    If Handled then
    begin
      Result := '<' + TagString;
      for i := 0 to TagParams.Count - 1 do
        If TagParams.Names[i] <> '' then
          Result := Result + ' ' + TagParams.Names[i] + '="' +
            alStringReplace(TagParams.ValueFromIndex[i], '"', '&#34;',
            [rfReplaceAll]) + '"'
        else
          Result := Result + ' ' + TagParams[i];
      Result := Result + '>';
    end;
  end;
end;

{ *************************** }
procedure TAlWebSpider.Crawl;
Var
  CurrentUrl: AnsiString;
  StopCrawling: Boolean;
  UrlRedirect: Boolean;
  DownloadError: Boolean;
  CurrentHttpResponseHeader: TALHTTPResponseHeader;
  CurrentHttpResponseContent: TStream;
  aExtData: _TAlWebSpiderHandleTagfunctExtData;
  pMimeTypeFromData: LPWSTR;
  Str: AnsiString;
Begin

  Try

    StopCrawling := false;
    If not assigned(fOnCrawlGetNextLink) then
      exit;

    { start the main loop }
    While true do
    begin

      CurrentUrl := '';
      fOnCrawlGetNextLink(self, CurrentUrl); { Get the current url to process }
      CurrentUrl := ALTrim(CurrentUrl);
      If CurrentUrl = '' then
        exit; { no more url to download then exit }

      UrlRedirect := false;
      DownloadError := false;
      CurrentHttpResponseContent := TmemoryStream.Create;
      CurrentHttpResponseHeader := TALHTTPResponseHeader.Create;
      Try

        Try

          { the onbeforedownloadevent }
          if assigned(fOnCrawlBeforeDownload) then
            fOnCrawlBeforeDownload(self, CurrentUrl);
          Try
            { download the page }
            FHttpClient.Get(CurrentUrl, CurrentHttpResponseContent,
              CurrentHttpResponseHeader);
          Finally
            { the onAfterdownloadevent }
            if assigned(fOnCrawlAfterDownload) then
              fOnCrawlAfterDownload(self, CurrentUrl, CurrentHttpResponseHeader,
                CurrentHttpResponseContent, StopCrawling);
          End;

        except
          on E: Exception do
          begin

            { in case of url redirect }
            If AlPos('3', CurrentHttpResponseHeader.StatusCode) = 1 then
            begin
              UrlRedirect := true;
              If assigned(fOnCrawlDownloadRedirect) then
                fOnCrawlDownloadRedirect(self, CurrentUrl,
                  AlCombineUrl(ALTrim(CurrentHttpResponseHeader.Location),
                  CurrentUrl), CurrentHttpResponseHeader, StopCrawling);
            end

            { in case of any other error }
            else
            begin
              DownloadError := true;
              If assigned(fOnCrawlDownloadError) then
                fOnCrawlDownloadError(self, CurrentUrl, AnsiString(E.Message),
                  CurrentHttpResponseHeader, StopCrawling);
            end;

          end;
        end;

        { download OK }
        If (not UrlRedirect) and (not DownloadError) then
        begin

          { if size = 0 their is nothing to do }
          if CurrentHttpResponseContent.Size > 0 then
          begin

            { read the content in Str }
            CurrentHttpResponseContent.Position := 0;
            SetLength(Str, CurrentHttpResponseContent.Size);
            CurrentHttpResponseContent.ReadBuffer(Str[1],
              CurrentHttpResponseContent.Size);

            { check the mime content type because some server send wrong mime content type }
            IF (FindMimeFromData(nil, // bind context - can be nil
              nil, // url - can be nil
              PAnsiChar(Str),
              // buffer with data to sniff - can be nil (pwzUrl must be valid)
              length(Str), // size of buffer
              PWidechar(WideString(CurrentHttpResponseHeader.ContentType)),
              // proposed mime if - can be nil
              0, // will be defined
              pMimeTypeFromData, // the suggested mime
              0 // must be 0
              ) <> NOERROR) then
              pMimeTypeFromData :=
                PWidechar(WideString(CurrentHttpResponseHeader.ContentType));

            { lanche the analyze of the page if content type = text/html }
            If ALSameText(AnsiString(pMimeTypeFromData), 'text/html') and
              assigned(FOnCrawlFindLink) then
            begin

              { init the CurrentBaseHref of the aExtData object }
              aExtData.WebSpiderObj := self;
              aExtData.CurrentBaseHref := CurrentUrl;

              { extract the list of url to download }
              ALHideHtmlUnwantedTagForHTMLHandleTagfunct(Str, false, #1);
              ALFastTagReplace(Str, '<', '>',
                _AlWebSpiderExtractUrlHandleTagfunct, true, @aExtData,
                [rfReplaceAll]);
            end;

          end;

          { trigger the event OnCrawlDownloadSuccess }
          if assigned(fOnCrawlDownloadSuccess) then
          begin
            CurrentHttpResponseContent.Position := 0;
            fOnCrawlDownloadSuccess(self, CurrentUrl, CurrentHttpResponseHeader,
              CurrentHttpResponseContent, StopCrawling);
          end;

        end;

        { if StopCrawling then exit }
        If StopCrawling then
          exit;

      finally
        CurrentHttpResponseContent.free;
        CurrentHttpResponseHeader.free;
      end;
    end;

  finally
    If assigned(FOnCrawlEnd) then
      FOnCrawlEnd(self);
  end;
end;

{ ******************************************* }
procedure TAlWebSpider.UpdateLinkToLocalPath;
Var
  currentFileName: AnsiString;
  CurrentBaseHref: AnsiString;
  aExtData: _TAlWebSpiderHandleTagfunctExtData;
  Str: AnsiString;
Begin

  Try

    If not assigned(fOnUpdateLinkToLocalPathGetNextFile) or
      not assigned(OnUpdateLinkToLocalPathFindLink) then
      exit;

    { start the main loop }
    While true do
    begin

      currentFileName := '';
      CurrentBaseHref := '';
      fOnUpdateLinkToLocalPathGetNextFile(self, currentFileName,
        CurrentBaseHref); { Get the current html file to process }
      currentFileName := ALTrim(currentFileName);
      CurrentBaseHref := ALTrim(CurrentBaseHref);
      If currentFileName = '' then
        exit; { no more file to update }

      iF FileExists(String(currentFileName)) then
      begin
        { DOWNLOAD THE BODY }
        Str := AlGetStringFromFile(currentFileName);

        { init the CurrentBaseHref of the aExtData object }
        aExtData.WebSpiderObj := self;
        aExtData.CurrentBaseHref := CurrentBaseHref;

        { Update the link }
        ALHideHtmlUnwantedTagForHTMLHandleTagfunct(Str, false, #1);
        Str := ALFastTagReplace(Str, '<', '>',
          _AlWebSpiderUpdateLinkToLocalPathHandleTagfunct, true, @aExtData,
          [rfReplaceAll]);

        { restore the page to it's original format }
        Str := alStringReplace(Str, #1, '<', [rfReplaceAll]);

        { save the result string }
        AlSaveStringToFile(Str, currentFileName);
      end;
    end;

  finally
    If assigned(fOnUpdateLinkToLocalPathEnd) then
      fOnUpdateLinkToLocalPathEnd(self);
  end;
end;

{ **************************************************** }
procedure TAlTrivialWebSpider.Crawl(aUrl: AnsiString);
begin
  Crawl(aUrl, nil, nil);
end;

{ **************************************************************************************************************** }
procedure TAlTrivialWebSpider.Crawl(aUrl: AnsiString; LstUrlCrawled: TALStrings;
  LstErrorEncountered: TALStrings);
Var
  aNode: TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode;
Begin
  { check the SaveDirectory }
  if (SaveDirectory <> '') and not directoryExists(String(SaveDirectory)) then
    Raise EALException.Create('The directory: ' + SaveDirectory +
      ' not exist!');
  if FHttpClient = nil then
    Raise EALException.Create('The HttpClient cannot be empty!');

  { init private var }
  fStartUrl := ALTrim(aUrl);
  FCurrentDeepLevel := 0;
  FCurrentLocalFileNameIndex := 0;
  fLstUrlCrawled := LstUrlCrawled;
  fLstErrorEncountered := LstErrorEncountered;
  FPageDownloadedBinTree := TAlStringKeyAVLBinaryTree.Create;
  FPageNotYetDownloadedBinTree := TAlStringKeyAVLBinaryTree.Create;
  Try

    { add editURL2Crawl.text to the fPageNotYetDownloadedBinTree }
    aNode := TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode.Create;
    aNode.ID := fStartUrl;
    aNode.DeepLevel := 0;
    FPageNotYetDownloadedBinTree.AddNode(aNode);

    { start the crawl }
    FWebSpider.HttpClient := FHttpClient;
    FWebSpider.OnCrawlBeforeDownload := OnCrawlBeforeDownload;
    FWebSpider.OnCrawlAfterDownload := OnCrawlAfterDownload;
    FWebSpider.Crawl;

    { update the link on downloaded page to local path }
    if fUpdateLinkToLocalPath then
      FWebSpider.UpdateLinkToLocalPath;

  finally
    FPageDownloadedBinTree.free;
    FPageNotYetDownloadedBinTree.free;
    fStartUrl := '';
    FCurrentDeepLevel := 0;
    FCurrentLocalFileNameIndex := 0;
    fLstUrlCrawled := nil;
    fLstErrorEncountered := nil;
    FWebSpider.HttpClient := nil;
  end;
end;

{ ************************************* }
constructor TAlTrivialWebSpider.Create;
begin
  FWebSpider := TAlWebSpider.Create;
  fStartUrl := '';
  fLstUrlCrawled := nil;
  fLstErrorEncountered := nil;
  FPageDownloadedBinTree := nil;
  FPageNotYetDownloadedBinTree := nil;
  FCurrentDeepLevel := 0;
  FCurrentLocalFileNameIndex := 0;
  fMaxDeepLevel := -1;
  fOnCrawlBeforeDownload := nil;
  fUpdateLinkToLocalPath := true;
  fExcludeMask := '';
  fStayInStartDomain := true;
  fSaveDirectory := '';
  fSplitDirectoryAmount := 5000;
  FHttpClient := nil;
  fIncludeMask := '*';
  fOnCrawlAfterDownload := nil;
  FOnCrawlFindLink := nil;
  fDownloadImage := false;
  fOnUpdateLinkToLocalPathProgress := nil;
  fOnCrawlProgress := nil;

  FWebSpider.OnCrawlDownloadError := WebSpiderCrawlDownloadError;
  FWebSpider.OnCrawlDownloadRedirect := WebSpiderCrawlDownloadRedirect;
  FWebSpider.OnCrawlDownloadSuccess := WebSpiderCrawlDownloadSuccess;
  FWebSpider.OnCrawlFindLink := WebSpiderCrawlFindLink;
  FWebSpider.OnCrawlGetNextLink := WebSpiderCrawlGetNextLink;
  FWebSpider.OnUpdateLinkToLocalPathFindLink :=
    WebSpiderUpdateLinkToLocalPathFindLink;
  FWebSpider.OnUpdateLinkToLocalPathGetNextFile :=
    WebSpiderUpdateLinkToLocalPathGetNextFile;
end;

{ ************************************* }
destructor TAlTrivialWebSpider.Destroy;
begin
  FWebSpider.free;
  inherited;
end;

{ ************************************************************************************** }
function TAlTrivialWebSpider.GetNextLocalFileName(aContentType: AnsiString)
  : AnsiString;
Var
  aExt: AnsiString;

  { ----------------------------------------- }
  Function SplitPathMakeFilename: AnsiString;
  begin
    Result := fSaveDirectory +
      ALIntToStr((FCurrentLocalFileNameIndex div fSplitDirectoryAmount) *
      fSplitDirectoryAmount + fSplitDirectoryAmount) + '\';
    If (not directoryExists(string(Result))) and (not createDir(string(Result)))
    then
      raise EALException.Create('cannot create dir: ' + Result);
    Result := Result + ALIntToStr(FCurrentLocalFileNameIndex) + aExt;
    inc(FCurrentLocalFileNameIndex);
  end;

Begin
  if fSaveDirectory = '' then
    Result := ''
  else
  begin
    aExt := AlLowerCase(ALGetDefaultFileExtFromMimeContentType(aContentType));
    // '.htm'

    If FCurrentLocalFileNameIndex = 0 then
    Begin
      Result := fSaveDirectory + 'Start' + aExt;
      inc(FCurrentLocalFileNameIndex);
    end
    else
      Result := SplitPathMakeFilename;
  end;
end;

{ ************************************************************************ }
procedure TAlTrivialWebSpider.WebSpiderCrawlDownloadError(Sender: TObject;
  Url, ErrorMessage: AnsiString; HTTPResponseHeader: TALHTTPResponseHeader;
  var StopCrawling: Boolean);
Var
  aNode: TAlTrivialWebSpider_PageDownloadedBinTreeNode;
begin
  { add the url to downloaded list }
  aNode := TAlTrivialWebSpider_PageDownloadedBinTreeNode.Create;
  aNode.ID := Url;
  aNode.Data := '!';
  If not FPageDownloadedBinTree.AddNode(aNode) then
    aNode.free;

  { delete the url from the not yet downloaded list }
  FPageNotYetDownloadedBinTree.DeleteNode(Url);

  { update label }
  if assigned(fLstErrorEncountered) then
    fLstErrorEncountered.Add(ErrorMessage);
  if assigned(fOnCrawlProgress) then
    fOnCrawlProgress(self, FPageNotYetDownloadedBinTree.nodeCount,
      FPageDownloadedBinTree.nodeCount, Url);
end;

{ *************************************************************************** }
procedure TAlTrivialWebSpider.WebSpiderCrawlDownloadRedirect(Sender: TObject;
  Url, RedirectedTo: AnsiString; HTTPResponseHeader: TALHTTPResponseHeader;
  var StopCrawling: Boolean);
Var
  aNode: TALStringKeyAVLBinaryTreeNode;
begin
  { add the url to downloaded list }
  aNode := TAlTrivialWebSpider_PageDownloadedBinTreeNode.Create;
  aNode.ID := Url;
  TAlTrivialWebSpider_PageDownloadedBinTreeNode(aNode).Data :=
    '=>' + RedirectedTo;
  If not FPageDownloadedBinTree.AddNode(aNode) then
    aNode.free;

  { delete the url from the not yet downloaded list }
  FPageNotYetDownloadedBinTree.DeleteNode(Url);

  { Stay in start site }
  If not fStayInStartDomain or
    (AlLowerCase(AlExtractHostNameFromUrl(ALTrim(fStartUrl)))
    = AlLowerCase(AlExtractHostNameFromUrl(RedirectedTo))) then
  begin

    { remove the anchor }
    RedirectedTo := AlRemoveAnchorFromUrl(RedirectedTo);

    { add the redirectTo url to the not yet downloaded list }
    If FPageDownloadedBinTree.FindNode(RedirectedTo) = nil then
    begin
      aNode := TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode.Create;
      aNode.ID := RedirectedTo;
      TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode(aNode).DeepLevel :=
        FCurrentDeepLevel;
      If not FPageNotYetDownloadedBinTree.AddNode(aNode) then
        aNode.free;
    end;

  end;

  { update label }
  if assigned(fOnCrawlProgress) then
    fOnCrawlProgress(self, FPageNotYetDownloadedBinTree.nodeCount,
      FPageDownloadedBinTree.nodeCount, Url);
end;

{ ************************************************************************** }
procedure TAlTrivialWebSpider.WebSpiderCrawlDownloadSuccess(Sender: TObject;
  Url: AnsiString; HTTPResponseHeader: TALHTTPResponseHeader;
  HttpResponseContent: TStream; var StopCrawling: Boolean);
Var
  aNode: TAlTrivialWebSpider_PageDownloadedBinTreeNode;
  Str: AnsiString;
  aFileName: AnsiString;
  pMimeTypeFromData: LPWSTR;
begin

  { put the content in str }
  HttpResponseContent.Position := 0;
  SetLength(Str, HttpResponseContent.Size);
  HttpResponseContent.ReadBuffer(Str[1], HttpResponseContent.Size);

  { we add a check here to be sure that the file is an http file (text file }
  { Some server send image with text/htm content type }
  IF (FindMimeFromData(nil, // bind context - can be nil
    nil, // url - can be nil
    PAnsiChar(Str),
    // buffer with data to sniff - can be nil (pwzUrl must be valid)
    length(Str), // size of buffer
    PWidechar(WideString(HTTPResponseHeader.ContentType)),
    // proposed mime if - can be nil
    0, // will be defined
    pMimeTypeFromData, // the suggested mime
    0 // must be 0
    ) <> NOERROR) then
    pMimeTypeFromData := PWidechar(WideString(HTTPResponseHeader.ContentType));

  { Get the FileName where to save the responseContent }
  aFileName := GetNextLocalFileName(AnsiString(pMimeTypeFromData));

  { If html then add <!-- saved from '+ URL +' -->' at the top of the file }
  if aFileName <> '' then
  begin
    If ALSameText(AnsiString(pMimeTypeFromData), 'text/html') then
    begin
      Str := '<!-- saved from ' + Url + ' -->' + #13#10 + Str;
      AlSaveStringToFile(Str, aFileName);
    end
    { Else Save the file without any change }
    else
      TmemoryStream(HttpResponseContent).SaveToFile(String(aFileName));
  end;

  { delete the Url from the PageNotYetDownloadedBinTree }
  FPageNotYetDownloadedBinTree.DeleteNode(Url);

  { add the url to the PageDownloadedBinTree }
  aNode := TAlTrivialWebSpider_PageDownloadedBinTreeNode.Create;
  aNode.ID := Url;
  aNode.Data := AlCopyStr(aFileName, length(fSaveDirectory) + 1, maxint);
  If not FPageDownloadedBinTree.AddNode(aNode) then
    aNode.free;

  { update label }
  if assigned(fLstUrlCrawled) then
    fLstUrlCrawled.Add(Url);
  if assigned(fOnCrawlProgress) then
    fOnCrawlProgress(self, FPageNotYetDownloadedBinTree.nodeCount,
      FPageDownloadedBinTree.nodeCount, Url);
end;

{ ******************************************************************* }
procedure TAlTrivialWebSpider.WebSpiderCrawlFindLink(Sender: TObject;
  HtmlTagString: AnsiString; HtmlTagParams: TALStrings; Url: AnsiString);
Var
  aNode: TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode;
  Lst: TALStringList;
  i: Integer;
  Flag1: Boolean;
  S1: AnsiString;
begin
  { If Check BoxDownload Image }
  IF not fDownloadImage and (ALSameText(HtmlTagString, 'img') or
    (ALSameText(HtmlTagString, 'input') and
    ALSameText(ALTrim(HtmlTagParams.Values['type']), 'image'))) then
    exit;

  { Stay in start site }
  If fStayInStartDomain and
    (AlLowerCase(AlExtractHostNameFromUrl(ALTrim(fStartUrl))) <>
    AlLowerCase(AlExtractHostNameFromUrl(Url))) then
    exit;

  { DeepLevel }
  If (fMaxDeepLevel >= 0) and (FCurrentDeepLevel + 1 > fMaxDeepLevel) then
    exit;

  { include link(s) }
  If fIncludeMask <> '' then
  begin
    Lst := TALStringList.Create;
    Try
      Lst.Text := ALTrim(alStringReplace(fIncludeMask, ';', #13#10,
        [rfReplaceAll]));
      Flag1 := true;
      For i := 0 to Lst.Count - 1 do
      begin
        S1 := ALTrim(Lst[i]);
        If S1 <> '' then
        begin
          Flag1 := ALMatchesMask(Url, S1);
          If Flag1 then
            Break;
        end;
      end;
      If not Flag1 then
        exit;
    Finally
      Lst.free;
    end;
  end;

  { Exclude link(s) }
  If fExcludeMask <> '' then
  begin
    Lst := TALStringList.Create;
    Try
      Lst.Text := ALTrim(alStringReplace(fExcludeMask, ';', #13#10,
        [rfReplaceAll]));
      Flag1 := false;
      For i := 0 to Lst.Count - 1 do
      begin
        S1 := ALTrim(Lst[i]);
        If S1 <> '' then
        begin
          Flag1 := ALMatchesMask(Url, S1);
          If Flag1 then
            Break;
        end;
      end;
      If Flag1 then
        exit;
    Finally
      Lst.free;
    end;
  end;

  { remove the anchor }
  Url := AlRemoveAnchorFromUrl(Url);

  { call OnCrawlFindLink }
  Flag1 := false;
  if assigned(FOnCrawlFindLink) then
    FOnCrawlFindLink(Sender, HtmlTagString, HtmlTagParams, Url, Flag1);
  if Flag1 then
    exit;

  { If the link not already downloaded then add it to the FPageNotYetDownloadedBinTree }
  If FPageDownloadedBinTree.FindNode(Url) = nil then
  begin
    aNode := TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode.Create;
    aNode.ID := Url;
    aNode.DeepLevel := FCurrentDeepLevel + 1;
    If not FPageNotYetDownloadedBinTree.AddNode(aNode) then
      aNode.free;
  end;
end;

{ ******************************************************************************************** }
procedure TAlTrivialWebSpider.WebSpiderCrawlGetNextLink(Sender: TObject;
  var Url: AnsiString);

{ ------------------------------------------------------------------------------------------------ }
  function InternalfindNextUrlToDownload
    (aNode: TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode;
    alowDeepLevel: Integer)
    : TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode;
  Var
    aTmpNode1, aTmpNode2: TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode;
  Begin
    If (not assigned(aNode)) or (aNode.DeepLevel <= alowDeepLevel) then
      Result := aNode
    else
    begin

      if aNode.ChildNodes[true] <> nil then
      begin
        aTmpNode1 := InternalfindNextUrlToDownload
          (TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode(aNode.ChildNodes
          [true]), alowDeepLevel);
        If (assigned(aTmpNode1)) and (aTmpNode1.DeepLevel <= alowDeepLevel) then
        begin
          Result := aTmpNode1;
          exit;
        end;
      end
      else
        aTmpNode1 := nil;

      if aNode.ChildNodes[false] <> nil then
      begin
        aTmpNode2 := InternalfindNextUrlToDownload
          (TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode(aNode.ChildNodes
          [false]), alowDeepLevel);
        If (assigned(aTmpNode2)) and (aTmpNode2.DeepLevel <= alowDeepLevel) then
        begin
          Result := aTmpNode2;
          exit;
        end;
      end
      else
        aTmpNode2 := nil;

      Result := aNode;
      If assigned(aTmpNode1) and (Result.DeepLevel > aTmpNode1.DeepLevel) then
        Result := aTmpNode1;
      If assigned(aTmpNode2) and (Result.DeepLevel > aTmpNode2.DeepLevel) then
        Result := aTmpNode2;

    end;
  end;

Var
  aNode: TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode;
begin
  { If theire is more url to download }
  IF FPageNotYetDownloadedBinTree.nodeCount > 0 then
  begin

    { Find next url with deeplevel closer to FCurrentDeepLevel }
    If fMaxDeepLevel >= 0 then
      aNode := InternalfindNextUrlToDownload
        (TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode
        (FPageNotYetDownloadedBinTree.head), FCurrentDeepLevel)

      { Find next url without take care of FCurrentDeepLevel }
    else
      aNode := TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode
        (FPageNotYetDownloadedBinTree.head);

    Url := aNode.ID;
    FCurrentDeepLevel := TAlTrivialWebSpider_PageNotYetDownloadedBinTreeNode
      (aNode).DeepLevel;
  end

  { If their is no more url to download then exit }
  else
  begin
    Url := '';
    FCurrentDeepLevel := -1;
  end;
end;

{ *********************************************************************************** }
procedure TAlTrivialWebSpider.WebSpiderUpdateLinkToLocalPathFindLink
  (Sender: TObject; HtmlTagString: AnsiString; HtmlTagParams: TALStrings;
  Url: AnsiString; var LocalPath: AnsiString);
Var
  aNode: TALStringKeyAVLBinaryTreeNode;
  aAnchorValue: AnsiString;
begin
  LocalPath := '';

  If Url <> '' then
  begin

    { Find the local Path }
    While true Do
    begin
      Url := AlRemoveAnchorFromUrl(Url, aAnchorValue);
      aNode := FPageDownloadedBinTree.FindNode(Url);
      If (aNode <> nil) then
      begin
        LocalPath := TAlTrivialWebSpider_PageDownloadedBinTreeNode(aNode).Data;
        If AlPos('=>', LocalPath) = 1 then
        Begin
          Url := AlCopyStr(LocalPath, 3, maxint);
          LocalPath := '';
        end
        else
          Break;
      end
      else
        Break;
    end;

    If LocalPath = '!' then
      LocalPath := ''
    else If LocalPath <> '' then
    begin
      LocalPath := alStringReplace(LocalPath, '\', '/', [rfReplaceAll]) +
        aAnchorValue;
      If (FCurrentLocalFileNameIndex >= 0) then
        LocalPath := '../' + LocalPath;
    end;
  end;
end;

{ ************************************************************************************** }
procedure TAlTrivialWebSpider.WebSpiderUpdateLinkToLocalPathGetNextFile
  (Sender: TObject; var FileName, BaseHref: AnsiString);
{ ----------------------------------------- }
  Function SplitPathMakeFilename: AnsiString;
  begin
    If FCurrentLocalFileNameIndex < 0 then
      Result := ''
    else If FCurrentLocalFileNameIndex = 0 then
      Result := fSaveDirectory + 'Start.htm'
    else
      Result := fSaveDirectory +
        ALIntToStr((FCurrentLocalFileNameIndex div SplitDirectoryAmount) *
        SplitDirectoryAmount + SplitDirectoryAmount) + '\' +
        ALIntToStr(FCurrentLocalFileNameIndex) + '.htm';
    dec(FCurrentLocalFileNameIndex);
  end;

Begin
  if fSaveDirectory = '' then
    FileName := ''
  else
  begin

    { Find FileName }
    FileName := SplitPathMakeFilename;
    While (FileName <> '') and not FileExists(string(FileName)) do
      FileName := SplitPathMakeFilename;

  end;

  { if filename found }
  If FileName <> '' then
  Begin

    { Extract the Base Href }
    BaseHref := AlGetStringFromFile(FileName);
    BaseHref := ALTrim(AlCopyStr(BaseHref, 17, // '<!-- saved from ' + URL
      AlPos(#13, BaseHref) - 21)); // URL + ' -->' +#13#10

    { update label }
    if assigned(fOnUpdateLinkToLocalPathProgress) then
      fOnUpdateLinkToLocalPathProgress(self, FileName);

  end
  else
    BaseHref := '';

end;

end.
