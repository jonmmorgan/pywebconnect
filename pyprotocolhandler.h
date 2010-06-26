#ifndef WXWEBCONNECT__PY_PROTOCOLHANDLER__H
#define WXWEBCONNECT__PY_PROTOCOLHANDLER__H

class wxPyProtocolHandler: public wxProtocolHandler   {
private:
    PyObject *m_handler;

public:
    wxPyProtocolHandler(PyObject *handler);
    virtual ~wxPyProtocolHandler();
    virtual wxString GetContent(const wxString& url);
    virtual wxString GetContentType(const wxString& url);
};

#endif
