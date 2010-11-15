/////////////////////////////////////////////////////////////////////////////
// Name:        wc.i
// Purpose:     
//
// Author:      Robin Dunn
//
// Created:     8-July-2009
// RCS-ID:      $Id: $
// Copyright:   (c) 2009 by Total Control Software
// Licence:     wxWindows license
/////////////////////////////////////////////////////////////////////////////

%define DOCSTRING
"WebConnect"
%enddef

%include "std_string.i"

%module(package="wx", docstring=DOCSTRING) wc

%{
#include "wx/wxPython/wxPython.h"
#include "wx/wxPython/pyclasses.h"

#include "webconnect/webcontrol.h"
#include "webconnect/dom.h"
#include "webconnect/protocolhandler.h"
#include "pyprotocolhandler.h"

#include <wx/listctrl.h>
#include <wx/treectrl.h>
#include <wx/imaglist.h>

class wxPyTreeCtrl;
%}

//---------------------------------------------------------------------------

%import windows.i
%import controls.i
%pythoncode { import wx }
%pythoncode { __docfilter__ = wx._core.__DocFilter(globals()) }


//---------------------------------------------------------------------------
enum wxWebState
{
    wxWEB_STATE_NONE =         0,
    wxWEB_STATE_START =        1 << 0,
    wxWEB_STATE_REDIRECTING =  1 << 1,
    wxWEB_STATE_TRANSFERRING = 1 << 2,
    wxWEB_STATE_NEGOTIATING =  1 << 3,
    wxWEB_STATE_STOP =         1 << 4,
    
    wxWEB_STATE_IS_REQUEST =   1 << 5,
    wxWEB_STATE_IS_DOCUMENT =  1 << 6,
    wxWEB_STATE_IS_NETWORK =   1 << 7,
    wxWEB_STATE_IS_WINDOW =    1 << 8,
};


enum wxWebResult
{
    wxWEB_RESULT_NONE =                     0,
    wxWEB_RESULT_SUCCESS =                  1 << 0,
    wxWEB_RESULT_UNKNOWN_PROTOCOL =         1 << 1,
    wxWEB_RESULT_FILE_NOT_FOUND =           1 << 2,
    wxWEB_RESULT_UNKNOWN_HOST =             1 << 3,
    wxWEB_RESULT_CONNECTION_REFUSED =       1 << 4,
    wxWEB_RESULT_NET_INTERRUPT =            1 << 5,
    wxWEB_RESULT_NET_TIMEOUT =              1 << 6,
    wxWEB_RESULT_MALFORMED_URI =            1 << 7,
    wxWEB_RESULT_REDIRECT_LOOP =            1 << 8,
    wxWEB_RESULT_UNKNOWN_SOCKET_TYPE =      1 << 9,
    wxWEB_RESULT_NET_RESET =                1 << 10,
    wxWEB_RESULT_DOCUMENT_NOT_CACHED =      1 << 11,
    wxWEB_RESULT_DOCUMENT_IS_PRINTMODE =    1 << 12,
    wxWEB_RESULT_PORT_ACCESS_NOT_ALLOWED =  1 << 13,
    wxWEB_RESULT_UNKNOWN_PROXY_HOST =       1 << 14,
    wxWEB_RESULT_PROXY_CONNECTION_REFUSED = 1 << 15
};


enum wxWebLoadFlag
{
    wxWEB_LOAD_NORMAL =        0,
    wxWEB_LOAD_LINKCLICK =     1 << 1
};


enum wxWebFindFlag
{
    wxWEB_FIND_BACKWARDS =     1 << 1,
    wxWEB_FIND_WRAP =          1 << 2,
    wxWEB_FIND_ENTIRE_WORD =   1 << 3,
    wxWEB_FIND_MATCH_CASE =    1 << 4,
    wxWEB_FIND_SEARCH_FRAMES = 1 << 5
};


enum wxWebDownloadAction
{
    wxWEB_DOWNLOAD_OPEN = 1,
    wxWEB_DOWNLOAD_SAVE = 2,
    wxWEB_DOWNLOAD_SAVEAS = 3,
    wxWEB_DOWNLOAD_CANCEL = 4
};


enum wxWebChromeFlags
{
    wxWEB_CHROME_MODAL =     1 << 1,
    wxWEB_CHROME_RESIZABLE = 1 << 2,
    wxWEB_CHROME_CENTER =    1 << 3,
    wxWEB_CHROME_CENTRE =    1 << 3,
};


enum wxWebDOMNodeType
{
    // see DOM Level 2 spec for more info
    wxWEB_NODETYPE_ELEMENT_NODE = 1,
    wxWEB_NODETYPE_ATTRIBUTE_NODE = 2,
    wxWEB_NODETYPE_TEXT_NODE = 3,
    wxWEB_NODETYPE_CDATA_SECTION_NODE = 4,
    wxWEB_NODETYPE_ENTITY_REFERENCE_NODE = 5,
    wxWEB_NODETYPE_ENTITY_NODE = 6,
    wxWEB_NODETYPE_PROCESSING_INSTRUCTION_NODE = 7,
    wxWEB_NODETYPE_COMMENT_NODE = 8,
    wxWEB_NODETYPE_DOCUMENT_NODE = 9,
    wxWEB_NODETYPE_DOCUMENT_TYPE_NODE = 10,
    wxWEB_NODETYPE_DOCUMENT_FRAGMENT_NODE = 11,
    wxWEB_NODETYPE_NOTATION_NODE = 12,
};



//---------------------------------------------------------------------------

MustHaveApp(wxWebControl);


class wxWebControl : public wxControl
{
public:

    static bool InitEngine(const wxString& path);
    static void InstallXRCHandler(wxXmlResource *res = NULL);
    static bool AddContentHandler(wxWebContentHandler* handler, bool take_ownership = false);
    static void AddPluginPath(const wxString& path);
    static wxWebPreferences GetPreferences();
    
    static bool SaveRequest(
                 const wxString& uri,
                 const wxString& destination_path,
                 wxWebPostData* post_data = NULL,
                 wxWebProgressBase* listener = NULL);
                 
    static bool SaveRequestToString(
                 const wxString& uri,
                 wxString* result = NULL,
                 wxWebPostData* post_data = NULL,
                 wxWebProgressBase* listener = NULL);
                 
    static bool ClearCache();
                 
public:
    %pythonAppend wxWebControl         "self._setOORInfo(self)"
    %pythonAppend wxWebControl()       ""

    %typemap(out) wxWebControl*;    // turn off this typemap
    wxWebControl(wxWindow* parent,
                 wxWindowID id = wxID_ANY,
                 const wxPoint& pos = wxDefaultPosition,
                 const wxSize& size = wxDefaultSize);
    %RenameCtor(PreWebControl, wxWebControl());

    // Turn it back on again
    %typemap(out) wxWebControl* { $result = wxPyMake_wxObject($1, $owner); }

    bool Create(wxWindow* parent,
                 wxWindowID id = wxID_ANY,
                 const wxPoint& pos = wxDefaultPosition,
                 const wxSize& size = wxDefaultSize);
   
    bool IsOk() const;
    
    // navigation
    void OpenURI(const wxString& uri,
                 unsigned int flags = wxWEB_LOAD_NORMAL,
                 wxWebPostData* post_data = NULL,
                 bool grab_focus = true);
                     
    bool SetContent(const wxString& strBaseURI, const wxString& strContent, const wxString& strContentType = wxT("text/html"));

    wxString GetCurrentURI() const;
    void GoForward();
    void GoBack();
    void Reload();
    void Stop();
    bool IsContentLoaded() const;
    
    // javascript
    bool Execute(const wxString& js_code);
    wxString ExecuteScriptWithResult(const wxString& js_code);
    
    // printing
    void Print(bool silent = false);
    void SetPageSettings(double page_width, double page_height,
                         double left_margin, double right_margin, double top_margin, double bottom_margin);
    //void GetPageSettings(double* page_width, double* page_height,
    //                     double* left_margin, double* right_margin, double* top_margin, double* bottom_margin);
    void GetPageSettings(double* OUTPUT, double* OUTPUT,
                         double* OUTPUT, double* OUTPUT, double* OUTPUT, double* OUTPUT);

    // view source
    %nokwargs ViewSource;
    void ViewSource();
    void ViewSource(wxWebControl* source_web_browser);
    void ViewSource(const wxString& uri);
    
    // save
    bool SaveCurrent(const wxString& destination_path);
    
    // zoom
    void GetTextZoom(float* zoom);
    void SetTextZoom(float zoom);

    // find
    bool Find(const wxString& text, unsigned int flags = 0);
    
    // clipboard
    bool CanCutSelection();
    bool CanCopySelection();
    bool CanCopyLinkLocation();
    bool CanCopyImageLocation();
    bool CanCopyImageContents();
    bool CanPaste();
    void CutSelection();
    void CopySelection();
    void CopyLinkLocation();
    void CopyImageLocation();
    void CopyImageContents();
    void Paste();
    void SelectAll();
    void SelectNone();
    
    // other
    wxImage GetFavIcon() const;
    wxDOMDocument GetDOMDocument();
    
};

class wxWebPreferences
{
friend class wxWebControl;

private:

    // private constructor - please use wxWebControl::GetWebPreferences()
    wxWebPreferences();
    
public:

    bool GetBoolPref(const wxString& name);
    wxString GetStringPref(const wxString& name);
    int GetIntPref(const wxString& name);

    void SetIntPref(const wxString& name, int value);
    void SetStringPref(const wxString& name, const wxString& value);
    void SetBoolPref(const wxString& name, bool value);
};

%pythoncode {
class wxWebPreferencesHelper(object):
    def __init__(self):
        self._preferences = None

    # XXX: I do not know any way to implement __getitem__(), since we cannot
    # guess what type of preference it is.
    def __getitem__(self, key):
        raise NotImplementedError("Use WebControl.GetPreferences() to get preference values.")

    def __setitem__(self, key, value):
        if not self._preferences:
            self._preferences = WebControl.GetPreferences()

        if isinstance(value, basestring):
            self._preferences.SetStringPref(key, value)
        elif isinstance(value, bool):
            self._preferences.SetBoolPref(key, value)
        elif isinstance(value, int):
            self._preferences.SetIntPref(key, value)
        else:
            raise ValueError("Unrecognised value type '%s' when setting preferences." % value)
        
WebControl.preferences = wxWebPreferencesHelper()
}

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------

%include "webconnect/dom.h"

/* This probably leaks memory, but it doesn't really matter as protocols
 * should be registered at the start of the application and stay registered
 * until the end of the application.
 */
%typemap(in) wxProtocolHandler*    { $1 = new wxPyProtocolHandler($input); }

bool RegisterProtocol(const wxString &scheme, wxProtocolHandler *handler);

%pythoncode {
class ProtocolHandler(object):
    def GetContent(self, url):
        return u""

    def GetContentType(self, url):
        return u"text/html"
}

enum wxProtocolHandlerURIOptions    {
    URI_STD = 0,
    URI_NORELATIVE = (1<<0),
    URI_NOAUTH = (1<<1),
    URI_INHERITS_SECURITY_CONTEXT = (1<<4),
    URI_FORBIDS_AUTOMATIC_DOCUMENT_REPLACEMENT = (1<<5),
    URI_LOADABLE_BY_ANYONE = (1<<6),
    URI_DANGEROUS_TO_LOAD = (1<<7),
    URI_IS_UI_RESOURCE = (1<<8),
    URI_IS_LOCAL_FILE = (1<<9),
    URI_NON_PERSISTABLE = (1<<10),
    URI_DOES_NOT_RETURN_DATA = (1<<11),
    URI_IS_LOCAL_RESOURCE = (1<<12),
    URI_OPENING_EXECUTES_SCRIPT = (1<<13)
};

///////////////////////////////////////////////////////////////////////////////
//  event declarations
///////////////////////////////////////////////////////////////////////////////

%constant wxEventType wxEVT_WEB_OPENURI;
%constant wxEventType wxEVT_WEB_TITLECHANGE;
%constant wxEventType wxEVT_WEB_LOCATIONCHANGE;
%constant wxEventType wxEVT_WEB_DOMCONTENTLOADED;
%constant wxEventType wxEVT_WEB_STATUSTEXT;
%constant wxEventType wxEVT_WEB_STATUSCHANGE;
%constant wxEventType wxEVT_WEB_STATECHANGE;
%constant wxEventType wxEVT_WEB_SHOWCONTEXTMENU;
%constant wxEventType wxEVT_WEB_CREATEBROWSER;
%constant wxEventType wxEVT_WEB_LEFTDOWN;
%constant wxEventType wxEVT_WEB_MIDDLEDOWN;
%constant wxEventType wxEVT_WEB_RIGHTDOWN;
%constant wxEventType wxEVT_WEB_LEFTUP;
%constant wxEventType wxEVT_WEB_MIDDLEUP;
%constant wxEventType wxEVT_WEB_RIGHTUP;
%constant wxEventType wxEVT_WEB_LEFTDCLICK;
%constant wxEventType wxEVT_WEB_MOUSEOVER;
%constant wxEventType wxEVT_WEB_MOUSEOUT;
%constant wxEventType wxEVT_WEB_DRAGDROP;
%constant wxEventType wxEVT_WEB_INITDOWNLOAD;
%constant wxEventType wxEVT_WEB_SHOULDHANDLECONTENT;
%constant wxEventType wxEVT_WEB_FAVICONAVAILABLE;
%constant wxEventType wxEVT_WEB_DOMEVENT;

%pythoncode {
EVT_WEB_OPENURI = wx.PyEventBinder( wxEVT_WEB_OPENURI, 1)
EVT_WEB_TITLECHANGE = wx.PyEventBinder( wxEVT_WEB_TITLECHANGE, 1)
EVT_WEB_LOCATIONCHANGE = wx.PyEventBinder( wxEVT_WEB_LOCATIONCHANGE, 1)
EVT_WEB_DOMCONTENTLOADED = wx.PyEventBinder( wxEVT_WEB_DOMCONTENTLOADED, 1)
EVT_WEB_STATUSTEXT = wx.PyEventBinder( wxEVT_WEB_STATUSTEXT, 1)
EVT_WEB_STATUSCHANGE = wx.PyEventBinder( wxEVT_WEB_STATUSCHANGE, 1)
EVT_WEB_STATECHANGE = wx.PyEventBinder( wxEVT_WEB_STATECHANGE, 1)
EVT_WEB_SHOWCONTEXTMENU = wx.PyEventBinder( wxEVT_WEB_SHOWCONTEXTMENU, 1)
EVT_WEB_CREATEBROWSER = wx.PyEventBinder( wxEVT_WEB_CREATEBROWSER, 1)
EVT_WEB_LEFTDOWN = wx.PyEventBinder( wxEVT_WEB_LEFTDOWN, 1)
EVT_WEB_MIDDLEDOWN = wx.PyEventBinder( wxEVT_WEB_MIDDLEDOWN, 1)
EVT_WEB_RIGHTDOWN = wx.PyEventBinder( wxEVT_WEB_RIGHTDOWN, 1)
EVT_WEB_LEFTUP = wx.PyEventBinder( wxEVT_WEB_LEFTUP, 1)
EVT_WEB_MIDDLEUP = wx.PyEventBinder( wxEVT_WEB_MIDDLEUP, 1)
EVT_WEB_RIGHTUP = wx.PyEventBinder( wxEVT_WEB_RIGHTUP, 1)
EVT_WEB_LEFTDCLICK = wx.PyEventBinder( wxEVT_WEB_LEFTDCLICK, 1)
EVT_WEB_MOUSEOVER = wx.PyEventBinder( wxEVT_WEB_MOUSEOVER, 1)
EVT_WEB_MOUSEOUT = wx.PyEventBinder( wxEVT_WEB_MOUSEOUT, 1)
EVT_WEB_DRAGDROP = wx.PyEventBinder( wxEVT_WEB_DRAGDROP, 1)
EVT_WEB_INITDOWNLOAD = wx.PyEventBinder( wxEVT_WEB_INITDOWNLOAD, 1)
EVT_WEB_SHOULDHANDLECONTENT = wx.PyEventBinder( wxEVT_WEB_SHOULDHANDLECONTENT, 1)
EVT_WEB_FAVICONAVAILABLE = wx.PyEventBinder( wxEVT_WEB_FAVICONAVAILABLE, 1)
EVT_WEB_DOMEVENT = wx.PyEventBinder( wxEVT_WEB_DOMEVENT, 1)
}

class wxWebEvent : public wxNotifyEvent
{
public:
    wxWebEvent(wxEventType command_type = wxEVT_NULL,
                       int win_id = 0);

    wxEvent *Clone() const;

    int GetState() const;
    void SetState(int value);
    
    int GetResult() const;
    void SetResult(int value);
    
    void SetHref(const wxString& value);
    wxString GetHref() const;
    
    void SetFilename(const wxString& value);
    wxString GetFilename() const;
    
    void SetContentType(const wxString& value);
    wxString GetContentType();
    
    wxDOMNode GetTargetNode();
    wxDOMEvent GetDOMEvent();
    
    int GetCreateChromeFlags();
    void SetCreateChromeFlags(int value);
    void SetCreateBrowser(wxWebControl* ctrl);
    
    void SetDownloadAction(int action);
    void SetDownloadTarget(const wxString& path);
    void SetDownloadListener(wxWebProgressBase* listener);
    
    void SetShouldHandle(bool value);
    void SetOutputContentType(const wxString& value);
    
    int m_state;
    int m_res;
    wxDOMNode m_target_node;
    wxDOMEvent m_dom_event;
    wxString m_href;
    wxString m_filename;
    bool m_should_handle;
    wxString m_content_type;
    wxString m_output_content_type;
    
    int m_create_chrome_flags;
    wxWebControl* m_create_browser;
    
    int m_download_action;
    wxString m_download_action_path;
    wxWebProgressBase* m_download_listener;
};
