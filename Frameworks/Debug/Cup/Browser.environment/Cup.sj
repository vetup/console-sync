@STATIC;1.0;p;5;Cup.jt;52709;@STATIC;1.0;I;25;Foundation/CPDictionary.jI;30;Foundation/CPNumberFormatter.jI;22;Foundation/CPRunLoop.jI;20;Foundation/CPTimer.jI;16;AppKit/CPAlert.jI;26;AppKit/CPArrayController.jI;24;AppKit/CPCompatibility.jI;19;AppKit/CPPlatform.jI;25;AppKit/CPPlatformWindow.jI;20;AppKit/CPTableView.jt;52412;objj_executeFile("Foundation/CPDictionary.j", NO);objj_executeFile("Foundation/CPNumberFormatter.j", NO);objj_executeFile("Foundation/CPRunLoop.j", NO);objj_executeFile("Foundation/CPTimer.j", NO);objj_executeFile("AppKit/CPAlert.j", NO);objj_executeFile("AppKit/CPArrayController.j", NO);objj_executeFile("AppKit/CPCompatibility.j", NO);objj_executeFile("AppKit/CPPlatform.j", NO);objj_executeFile("AppKit/CPPlatformWindow.j", NO);objj_executeFile("AppKit/CPTableView.j", NO);{var the_typedef = objj_allocateTypeDef("jQueryEvent");
objj_registerTypeDef(the_typedef);
}CupFileStatusPending = 0;
CupFileStatusUploading = 1;
CupFileStatusComplete = 2;
CupFilteredName = 1 << 0;
CupFilteredSize = 1 << 1;
var FileStatuses = [];
var baseWidgetId = "Cup_input",
    delegateFilter = 1 << 0,
    delegateWillAdd = 1 << 1,
    delegateAdd = 1 << 2,
    delegateSubmit = 1 << 3,
    delegateSend = 1 << 4,
    delegateSucceed = 1 << 5,
    delegateFail = 1 << 6,
    delegateComplete = 1 << 7,
    delegateStop = 1 << 8,
    delegateFileProgress = 1 << 9,
    delegateProgress = 1 << 10,
    delegateStart = 1 << 11,
    delegateStop = 1 << 12,
    delegateChange = 1 << 13,
    delegatePaste = 1 << 14,
    delegateDrop = 1 << 15,
    delegateDrag = 1 << 16,
    delegateChunkWillSend = 1 << 17,
    delegateChunkSucceed = 1 << 18,
    delegateChunkFail = 1 << 19,
    delegateChunkComplete = 1 << 20,
    delegateStartQueue = 1 << 21,
    delegateClearQueue = 1 << 22,
    delegateStopQueue = 1 << 23;
var CupDefaultProgressInterval = 100;
{var the_class = objj_allocateClassPair(CPObject, "Cup"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("fileUploadOptions"), new objj_ivar("URL"), new objj_ivar("redirectURL"), new objj_ivar("sequential"), new objj_ivar("maxChunkSize"), new objj_ivar("maxConcurrentUploads"), new objj_ivar("progressInterval"), new objj_ivar("dropTarget"), new objj_ivar("jQueryDropTarget"), new objj_ivar("filenameFilter"), new objj_ivar("filenameFilterRegex"), new objj_ivar("maxFileSize"), new objj_ivar("autoUpload"), new objj_ivar("removeCompletedFiles"), new objj_ivar("currentEvent"), new objj_ivar("currentData"), new objj_ivar("uploading"), new objj_ivar("indeterminate"), new objj_ivar("progress"), new objj_ivar("delegate"), new objj_ivar("delegateImplementsFlags"), new objj_ivar("fileClass"), new objj_ivar("widgetId"), new objj_ivar("callbacks"), new objj_ivar("queue"), new objj_ivar("queueController")]);objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("URL"), function $Cup__URL(self, _cmd)
{
    return self.URL;
}
,["CPString"]), new objj_method(sel_getUid("setURL:"), function $Cup__setURL_(self, _cmd, newValue)
{
    self.URL = newValue;
}
,["void","CPString"]), new objj_method(sel_getUid("redirectURL"), function $Cup__redirectURL(self, _cmd)
{
    return self.redirectURL;
}
,["CPString"]), new objj_method(sel_getUid("setRedirectURL:"), function $Cup__setRedirectURL_(self, _cmd, newValue)
{
    self.redirectURL = newValue;
}
,["void","CPString"]), new objj_method(sel_getUid("sequential"), function $Cup__sequential(self, _cmd)
{
    return self.sequential;
}
,["BOOL"]), new objj_method(sel_getUid("setSequential:"), function $Cup__setSequential_(self, _cmd, newValue)
{
    self.sequential = newValue;
}
,["void","BOOL"]), new objj_method(sel_getUid("maxChunkSize"), function $Cup__maxChunkSize(self, _cmd)
{
    return self.maxChunkSize;
}
,["int"]), new objj_method(sel_getUid("setMaxChunkSize:"), function $Cup__setMaxChunkSize_(self, _cmd, newValue)
{
    self.maxChunkSize = newValue;
}
,["void","int"]), new objj_method(sel_getUid("maxConcurrentUploads"), function $Cup__maxConcurrentUploads(self, _cmd)
{
    return self.maxConcurrentUploads;
}
,["int"]), new objj_method(sel_getUid("setMaxConcurrentUploads:"), function $Cup__setMaxConcurrentUploads_(self, _cmd, newValue)
{
    self.maxConcurrentUploads = newValue;
}
,["void","int"]), new objj_method(sel_getUid("progressInterval"), function $Cup__progressInterval(self, _cmd)
{
    return self.progressInterval;
}
,["int"]), new objj_method(sel_getUid("setProgressInterval:"), function $Cup__setProgressInterval_(self, _cmd, newValue)
{
    self.progressInterval = newValue;
}
,["void","int"]), new objj_method(sel_getUid("dropTarget"), function $Cup__dropTarget(self, _cmd)
{
    return self.dropTarget;
}
,["CPView"]), new objj_method(sel_getUid("filenameFilter"), function $Cup__filenameFilter(self, _cmd)
{
    return self.filenameFilter;
}
,["CPString"]), new objj_method(sel_getUid("setFilenameFilter:"), function $Cup__setFilenameFilter_(self, _cmd, newValue)
{
    self.filenameFilter = newValue;
}
,["void","CPString"]), new objj_method(sel_getUid("filenameFilterRegex"), function $Cup__filenameFilterRegex(self, _cmd)
{
    return self.filenameFilterRegex;
}
,["RegExp"]), new objj_method(sel_getUid("setFilenameFilterRegex:"), function $Cup__setFilenameFilterRegex_(self, _cmd, newValue)
{
    self.filenameFilterRegex = newValue;
}
,["void","RegExp"]), new objj_method(sel_getUid("maxFileSize"), function $Cup__maxFileSize(self, _cmd)
{
    return self.maxFileSize;
}
,["int"]), new objj_method(sel_getUid("setMaxFileSize:"), function $Cup__setMaxFileSize_(self, _cmd, newValue)
{
    self.maxFileSize = newValue;
}
,["void","int"]), new objj_method(sel_getUid("autoUpload"), function $Cup__autoUpload(self, _cmd)
{
    return self.autoUpload;
}
,["BOOL"]), new objj_method(sel_getUid("setAutoUpload:"), function $Cup__setAutoUpload_(self, _cmd, newValue)
{
    self.autoUpload = newValue;
}
,["void","BOOL"]), new objj_method(sel_getUid("removeCompletedFiles"), function $Cup__removeCompletedFiles(self, _cmd)
{
    return self.removeCompletedFiles;
}
,["BOOL"]), new objj_method(sel_getUid("setRemoveCompletedFiles:"), function $Cup__setRemoveCompletedFiles_(self, _cmd, newValue)
{
    self.removeCompletedFiles = newValue;
}
,["void","BOOL"]), new objj_method(sel_getUid("currentEvent"), function $Cup__currentEvent(self, _cmd)
{
    return self.currentEvent;
}
,["jQueryEvent"]), new objj_method(sel_getUid("currentData"), function $Cup__currentData(self, _cmd)
{
    return self.currentData;
}
,["JSObject"]), new objj_method(sel_getUid("uploading"), function $Cup__uploading(self, _cmd)
{
    return self.uploading;
}
,["BOOL"]), new objj_method(sel_getUid("setUploading:"), function $Cup__setUploading_(self, _cmd, newValue)
{
    self.uploading = newValue;
}
,["void","BOOL"]), new objj_method(sel_getUid("indeterminate"), function $Cup__indeterminate(self, _cmd)
{
    return self.indeterminate;
}
,["BOOL"]), new objj_method(sel_getUid("setIndeterminate:"), function $Cup__setIndeterminate_(self, _cmd, newValue)
{
    self.indeterminate = newValue;
}
,["void","BOOL"]), new objj_method(sel_getUid("progress"), function $Cup__progress(self, _cmd)
{
    return self.progress;
}
,["CPMutableDictionary"]), new objj_method(sel_getUid("setProgress:"), function $Cup__setProgress_(self, _cmd, newValue)
{
    self.progress = newValue;
}
,["void","CPMutableDictionary"]), new objj_method(sel_getUid("delegate"), function $Cup__delegate(self, _cmd)
{
    return self.delegate;
}
,["id"]), new objj_method(sel_getUid("fileClass"), function $Cup__fileClass(self, _cmd)
{
    return self.fileClass;
}
,["Class"]), new objj_method(sel_getUid("setFileClass:"), function $Cup__setFileClass_(self, _cmd, newValue)
{
    self.fileClass = newValue;
}
,["void","Class"]), new objj_method(sel_getUid("queue"), function $Cup__queue(self, _cmd)
{
    return self.queue;
}
,["CPMutableArray"]), new objj_method(sel_getUid("queueController"), function $Cup__queueController(self, _cmd)
{
    return self.queueController;
}
,["CPArrayController"]), new objj_method(sel_getUid("initWithURL:"), function $Cup__initWithURL_(self, _cmd, aURL)
{
    self = (self == null ? null : self.isa.objj_msgSend0(self, "init"));
    if (self)
        (self == null ? null : self.isa.objj_msgSend1(self, "setURL:", aURL));
    return self;
}
,["id","CPString"]), new objj_method(sel_getUid("init"), function $Cup__init(self, _cmd)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("Cup").super_class }, "init");
    if (self)
        (self == null ? null : self.isa.objj_msgSend0(self, "_init"));
    return self;
}
,["id"]), new objj_method(sel_getUid("options"), function $Cup__options(self, _cmd)
{
    return cloneOptions(self.isa.objj_msgSend0(self, "makeOptions"));
}
,["JSObject"]), new objj_method(sel_getUid("setOptions:"), function $Cup__setOptions_(self, _cmd, options)
{
    self.fileUploadOptions = cloneOptions(options);
    self.isa.objj_msgSend1(self, "setURL:", options["url"] || "");
    self.isa.objj_msgSend1(self, "setSequential:", options["sequential"] || NO);
    self.isa.objj_msgSend1(self, "setMaxChunkSize:", options["maxChunkSize"] || 0);
    self.isa.objj_msgSend1(self, "setMaxConcurrentUploads:", options["limitConcurrentUploads"] || 0);
    self.isa.objj_msgSend1(self, "setProgressInterval:", options["progressInterval"] || CupDefaultProgressInterval);
}
,["void","JSObject"]), new objj_method(sel_getUid("setDropTarget:"), function $Cup__setDropTarget_(self, _cmd, target)
{
    self.dropTarget = target;
    if (self.dropTarget === CPPlatformWindow.isa.objj_msgSend0(CPPlatformWindow, "primaryPlatformWindow"))
        self.jQueryDropTarget = jQuery(document);
    else if (!self.dropTarget)
        self.jQueryDropTarget = nil;
    else
        self.jQueryDropTarget = jQuery(self.dropTarget._DOMElement);
    (jQuery(document))[self.dropTarget ? "bind" : "unbind"]('drop dragover', function(e)
    {
        e.preventDefault();
    });
}
,["void","CPView"]), new objj_method(sel_getUid("setDelegate:"), function $Cup__setDelegate_(self, _cmd, aDelegate)
{
    if (aDelegate === self.delegate)
        return;
    self.delegateImplementsFlags = 0;
    self.delegate = aDelegate;
    if (!self.delegate)
        return;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:didFilterFile:because:"))))
        self.delegateImplementsFlags |= delegateFilter;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:willAddFile:"))))
        self.delegateImplementsFlags |= delegateWillAdd;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:didAddFile:"))))
        self.delegateImplementsFlags |= delegateAdd;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cupDidStart:"))))
        self.delegateImplementsFlags |= delegateStart;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:willSubmitFile:"))))
        self.delegateImplementsFlags |= delegateSubmit;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:willSendFile:"))))
        self.delegateImplementsFlags |= delegateSend;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:chunkWillSendForFile:"))))
        self.delegateImplementsFlags |= delegateChunkWillSend;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:chunkDidSucceedForFile:"))))
        self.delegateImplementsFlags |= delegateChunkSucceed;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:chunkDidFailForFile:"))))
        self.delegateImplementsFlags |= delegateChunkFail;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:chunkDidCompleteForFile:"))))
        self.delegateImplementsFlags |= delegateChunkComplete;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:uploadForFile:didProgress:"))))
        self.delegateImplementsFlags |= delegateFileProgress;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:uploadsDidProgress:"))))
        self.delegateImplementsFlags |= delegateProgress;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:uploadDidSucceedForFile:"))))
        self.delegateImplementsFlags |= delegateSucceed;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:uploadDidFailForFile:"))))
        self.delegateImplementsFlags |= delegateFail;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:uploadDidCompleteForFile:"))))
        self.delegateImplementsFlags |= delegateComplete;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:uploadWasStoppedForFile:"))))
        self.delegateImplementsFlags |= delegateStop;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cupDidStop:"))))
        self.delegateImplementsFlags |= delegateStop;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:fileInputDidSelectFiles:"))))
        self.delegateImplementsFlags |= delegateChange;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cupDidStartQueue:"))))
        self.delegateImplementsFlags |= delegateStartQueue;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cupDidClearQueue:"))))
        self.delegateImplementsFlags |= delegateClearQueue;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cupDidStopQueue:"))))
        self.delegateImplementsFlags |= delegateStopQueue;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:didPasteFiles:"))))
        self.delegateImplementsFlags |= delegatePaste;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:didDropFiles:"))))
        self.delegateImplementsFlags |= delegateDrop;
    if (((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "respondsToSelector:", sel_getUid("cup:wasDraggedOverWithEvent:"))))
        self.delegateImplementsFlags |= delegateDrag;
    var ___r1;
}
,["void","id"]), new objj_method(sel_getUid("setFileClass:"), function $Cup__setFileClass_(self, _cmd, aClass)
{
    if ((aClass == null ? null : aClass.isa.objj_msgSend1(aClass, "isKindOfClass:", CPString.isa.objj_msgSend0(CPString, "class"))))
        aClass = CPClassFromString(aClass);
    if ((aClass == null ? null : aClass.isa.objj_msgSend1(aClass, "isKindOfClass:", (CupFile == null ? null : CupFile.isa.objj_msgSend0(CupFile, "class")))))
    {
        self.fileClass = aClass;
        ((___r1 = self.isa.objj_msgSend0(self, "queueController")), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "setObjectClass:", self.fileClass));
    }
    else
        CPLog.warn("%s: %s the file class must be a subclass of CupFile.", self.isa.objj_msgSend0(self, "className"), (aClass == null ? null : aClass.isa.objj_msgSend0(aClass, "className")));
    var ___r1;
}
,["void","Class"]), new objj_method(sel_getUid("setFilenameFilter:"), function $Cup__setFilenameFilter_(self, _cmd, aFilter)
{
    self.isa.objj_msgSend2(self, "_setFilenameFilter:caseSensitive:", aFilter, YES);
}
,["void","CPString"]), new objj_method(sel_getUid("setFilenameFilter:caseSensitive:"), function $Cup__setFilenameFilter_caseSensitive_(self, _cmd, aFilter, caseSensitive)
{
    self.isa.objj_msgSend2(self, "_setFilenameFilter:caseSensitive:", aFilter, caseSensitive);
}
,["void","CPString","BOOL"]), new objj_method(sel_getUid("setFilenameFilterRegex:"), function $Cup__setFilenameFilterRegex_(self, _cmd, regex)
{
    if ((self.filenameFilterRegex || "").toString() === (regex || "").toString())
        return;
    self.isa.objj_msgSend1(self, "willChangeValueForKey:", "filenameFilterRegex");
    self.isa.objj_msgSend1(self, "willChangeValueForKey:", "filenameFilter");
    self.filenameFilterRegex = regex;
    if (regex)
    {
        self.filenameFilter = (regex.toString()).replace(/^\/(.*)\/\w*$/, "$1");
    }
    else
        self.filenameFilter = "";
    self.isa.objj_msgSend1(self, "didChangeValueForKey:", "filenameFilter");
    self.isa.objj_msgSend1(self, "didChangeValueForKey:", "filenameFilterRegex");
}
,["void","RegExp"]), new objj_method(sel_getUid("setAllowedExtensions:"), function $Cup__setAllowedExtensions_(self, _cmd, extensions)
{
    var filter = "";
    if (extensions)
    {
        if ((extensions == null ? null : extensions.isa.objj_msgSend1(extensions, "isKindOfClass:", CPString.isa.objj_msgSend0(CPString, "class"))))
            extensions = extensions.split(/\s+/);
        (extensions == null ? null : extensions.isa.objj_msgSend1(extensions, "enumerateObjectsUsingBlock:", function(extension)
        {
            extension = extension.replace(/^\./, "");
        }));
        filter = CPString.isa.objj_msgSend2(CPString, "stringWithFormat:", "^.+\\.(%@)$", extensions.join("|"));
    }
    self.isa.objj_msgSend2(self, "setFilenameFilter:caseSensitive:", filter, NO);
}
,["void","id"]), new objj_method(sel_getUid("queueController"), function $Cup__queueController(self, _cmd)
{
    if (!self.queueController)
    {
        if (self.queue === nil)
            self.queue = [];
        self.queueController = ((___r1 = CPArrayController.isa.objj_msgSend0(CPArrayController, "alloc")), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "initWithContent:", self.queue));
        ((___r1 = self.queueController), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "setObjectClass:", ((___r2 = self.fileClass), ___r2 == null ? null : ___r2.isa.objj_msgSend0(___r2, "class"))));
        ((___r1 = self.queueController), ___r1 == null ? null : ___r1.isa.objj_msgSend(___r1, "addObserver:forKeyPath:options:context:", self, "content", 0, nil));
    }
    return self.queueController;
    var ___r1, ___r2;
}
,["CPArrayController"]), new objj_method(sel_getUid("addFiles:"), function $Cup__addFiles_(self, _cmd, sender)
{
    (jQuery("#" + self.widgetId))[0].click();
}
,["void","id"]), new objj_method(sel_getUid("start:"), function $Cup__start_(self, _cmd, sender)
{
    self.isa.objj_msgSend2(self, "fileUpload:", "option", self.isa.objj_msgSend0(self, "makeOptions"));
    if (!self.URL)
    {
        CPLog.error("%s: The URL has not been set.", self.isa.objj_msgSend0(self, "className"));
        return;
    }
    ((___r1 = self.queue), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "makeObjectsPerformSelector:", sel_getUid("submit")));
    if (self.delegateImplementsFlags & delegateStartQueue)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "cupDidStartQueue:", self));
    var ___r1;
}
,["void","id"]), new objj_method(sel_getUid("stop:"), function $Cup__stop_(self, _cmd, sender)
{
    if (self.delegateImplementsFlags & delegateStopQueue)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "cupDidStopQueue:", self));
    ((___r1 = self.queue), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "makeObjectsPerformSelector:", sel_getUid("stop")));
    self.isa.objj_msgSend1(self, "setUploading:", NO);
    var ___r1;
}
,["void","id"]), new objj_method(sel_getUid("clearQueue:"), function $Cup__clearQueue_(self, _cmd, sender)
{
    if (self.uploading)
        return;
    ((___r1 = self.queue), ___r1 == null ? null : ___r1.isa.objj_msgSend0(___r1, "removeAllObjects"));
    ((___r1 = self.isa.objj_msgSend0(self, "queueController")), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "setContent:", self.queue));
    self.isa.objj_msgSend0(self, "resetProgress");
    if (self.delegateImplementsFlags & delegateClearQueue)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "cupDidClearQueue:", self));
    var ___r1;
}
,["void","id"]), new objj_method(sel_getUid("fileWithUID:"), function $Cup__fileWithUID_(self, _cmd, aUID)
{
    var file = ((___r1 = self.queue), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "objectAtIndex:", ((___r2 = self.queue), ___r2 == null ? null : ___r2.isa.objj_msgSend1(___r2, "indexOfObjectPassingTest:", function(file)
    {
        return (file == null ? null : file.isa.objj_msgSend0(file, "UID")) === aUID;
    }))));
    return file;
    var ___r1, ___r2;
}
,["CupFile","CPString"]), new objj_method(sel_getUid("awakeFromCib"), function $Cup__awakeFromCib(self, _cmd)
{
    ((___r1 = self.queueController), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "setContent:", self.queue));
    ((___r1 = self.queueController), ___r1 == null ? null : ___r1.isa.objj_msgSend(___r1, "addObserver:forKeyPath:options:context:", self, "content", 0, nil));
    var ___r1;
}
,["void"]), new objj_method(sel_getUid("observeValueForKeyPath:ofObject:change:context:"), function $Cup__observeValueForKeyPath_ofObject_change_context_(self, _cmd, aKeyPath, anObject, changeDict, context)
{
    if (aKeyPath === "content")
    {
        self.isa.objj_msgSend0(self, "resetProgress");
    }
}
,["void","CPString","id","CPDictionary","JSObject"]), new objj_method(sel_getUid("addFile:"), function $Cup__addFile_(self, _cmd, file)
{
    var filterFlags = self.isa.objj_msgSend1(self, "validateFile:", file),
        canAdd = filterFlags === 0,
        cupFile = ((___r1 = ((___r2 = self.fileClass), ___r2 == null ? null : ___r2.isa.objj_msgSend0(___r2, "alloc"))), ___r1 == null ? null : ___r1.isa.objj_msgSend3(___r1, "initWithCup:file:data:", self, file, self.currentData));
    if (canAdd)
    {
        if (self.delegateImplementsFlags & delegateWillAdd)
            canAdd = ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:willAddFile:", self, cupFile));
    }
    else if (self.delegateImplementsFlags & delegateFilter)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend3(___r1, "cup:didFilterFile:because:", self, cupFile, filterFlags));
    else
        self.isa.objj_msgSend2(self, "fileWasRejected:because:", cupFile, filterFlags);
    if (canAdd)
    {
        ((___r1 = self.isa.objj_msgSend0(self, "queueController")), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "addObject:", cupFile));
        if (self.delegateImplementsFlags & delegateAdd)
            ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:didAddFile:", self, cupFile));
        if (self.autoUpload)
        {
            self.isa.objj_msgSend2(self, "fileUpload:", "option", self.isa.objj_msgSend0(self, "makeOptions"));
            (cupFile == null ? null : cupFile.isa.objj_msgSend0(cupFile, "submit"));
        }
    }
    var ___r1, ___r2;
}
,["void","JSFile"]), new objj_method(sel_getUid("uploadDidStart"), function $Cup__uploadDidStart(self, _cmd)
{
    ((___r1 = self.isa.objj_msgSend0(self, "queueController")), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "setSelectionIndexes:", CPIndexSet.isa.objj_msgSend0(CPIndexSet, "indexSet")));
    self.isa.objj_msgSend1(self, "setUploading:", YES);
    if (self.delegateImplementsFlags & delegateStart)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "cupDidStart:", self));
    var ___r1;
}
,["void"]), new objj_method(sel_getUid("submitFile:"), function $Cup__submitFile_(self, _cmd, file)
{
    if (!self.URL)
    {
        CPLog.error("%s: The URL has not been set.", self.isa.objj_msgSend0(self, "className"));
        return NO;
    }
    var canSubmit = YES;
    if (self.delegateImplementsFlags & delegateSubmit)
        canSubmit = ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:willSubmitFile:", self, file));
    return canSubmit;
    var ___r1;
}
,["BOOL","CupFile"]), new objj_method(sel_getUid("willSendFile:"), function $Cup__willSendFile_(self, _cmd, file)
{
    var canSend = YES;
    if (self.delegateImplementsFlags & delegateSend)
        canSend = ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:willSendFile:", self, file));
    if (canSend)
        (file == null ? null : file.isa.objj_msgSend0(file, "start"));
    return canSend;
    var ___r1;
}
,["BOOL","CupFile"]), new objj_method(sel_getUid("chunkWillSendForFile:"), function $Cup__chunkWillSendForFile_(self, _cmd, file)
{
    if (self.delegateImplementsFlags & delegateChunkWillSend)
        return ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:willSendChunkForFile:", self, file));
    return YES;
    var ___r1;
}
,["BOOL","CupFile"]), new objj_method(sel_getUid("chunkDidSucceedForFile:"), function $Cup__chunkDidSucceedForFile_(self, _cmd, file)
{
    (file == null ? null : file.isa.objj_msgSend1(file, "setUploadedBytes:", self.currentData.loaded));
    if (self.delegateImplementsFlags & delegateChunkSucceed)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:chunkDidSucceedForFile:", self, file));
    var ___r1;
}
,["void","CupFile"]), new objj_method(sel_getUid("chunkDidFailForFile:"), function $Cup__chunkDidFailForFile_(self, _cmd, file)
{
    if (self.delegateImplementsFlags & delegateChunkFail)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:chunkDidFailForFile:", self, file));
    var ___r1;
}
,["void","CupFile"]), new objj_method(sel_getUid("chunkDidCompleteForFile:"), function $Cup__chunkDidCompleteForFile_(self, _cmd, file)
{
    if (self.delegateImplementsFlags & delegateChunkComplete)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:chunkDidCompleteForFile:", self, file));
    var ___r1;
}
,["void","CupFile"]), new objj_method(sel_getUid("uploadForFile:didProgress:"), function $Cup__uploadForFile_didProgress_(self, _cmd, file, fileProgress)
{
    if (fileProgress.uploadedBytes)
        (file == null ? null : file.isa.objj_msgSend1(file, "setUploadedBytes:", fileProgress.uploadedBytes));
    (file == null ? null : file.isa.objj_msgSend1(file, "setBitrate:", fileProgress.bitrate));
    if (self.delegateImplementsFlags & delegateFileProgress)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend3(___r1, "cup:uploadForFile:didProgress:", self, file, fileProgress));
    var ___r1;
}
,["void","CupFile","JSObject"]), new objj_method(sel_getUid("uploadsDidProgress:"), function $Cup__uploadsDidProgress_(self, _cmd, overallProgress)
{
    self.isa.objj_msgSend(self, "updateProgressWithUploadedBytes:total:percentComplete:bitrate:", overallProgress.uploadedBytes, overallProgress.total, overallProgress.uploadedBytes / overallProgress.total * 100, overallProgress.bitrate);
    if (self.delegateImplementsFlags & delegateProgress)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:uploadsDidProgress:", self, overallProgress));
    var ___r1;
}
,["void","JSObject"]), new objj_method(sel_getUid("uploadDidSucceedForFile:"), function $Cup__uploadDidSucceedForFile_(self, _cmd, file)
{
    (file == null ? null : file.isa.objj_msgSend1(file, "setStatus:", CupFileStatusComplete));
    if (self.currentData.loaded)
        (file == null ? null : file.isa.objj_msgSend1(file, "setUploadedBytes:", self.currentData.loaded));
    if (self.currentData.bitrate)
        (file == null ? null : file.isa.objj_msgSend1(file, "setBitrate:", self.currentData.bitrate));
    if (self.delegateImplementsFlags & delegateSucceed)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:uploadDidSucceedForFile:", self, file));
    var ___r1;
}
,["void","CupFile"]), new objj_method(sel_getUid("uploadDidFailForFile:"), function $Cup__uploadDidFailForFile_(self, _cmd, file)
{
    (file == null ? null : file.isa.objj_msgSend1(file, "setStatus:", CupFileStatusPending));
    if (self.delegateImplementsFlags & delegateFail)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:uploadDidFailForFile:", self, file));
    var ___r1;
}
,["void","CupFile"]), new objj_method(sel_getUid("uploadDidCompleteForFile:"), function $Cup__uploadDidCompleteForFile_(self, _cmd, file)
{
    (file == null ? null : file.isa.objj_msgSend1(file, "setUploading:", NO));
    if (self.delegateImplementsFlags & delegateComplete)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:uploadDidCompleteForFile:", self, file));
    var ___r1;
}
,["void","CupFile"]), new objj_method(sel_getUid("uploadWasStoppedForFile:"), function $Cup__uploadWasStoppedForFile_(self, _cmd, file)
{
    if (self.delegateImplementsFlags & delegateStop)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:uploadWasStoppedForFile:", self, file));
    var ___r1;
}
,["void","CupFile"]), new objj_method(sel_getUid("uploadDidStop"), function $Cup__uploadDidStop(self, _cmd)
{
    self.isa.objj_msgSend1(self, "setUploading:", NO);
    if (self.delegateImplementsFlags & delegateStop)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "cupDidStop:", self));
    if (self.removeCompletedFiles)
    {
        var indexes = ((___r1 = self.queue), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "indexesOfObjectsPassingTest:", function(file)
        {
            return (file == null ? null : file.isa.objj_msgSend0(file, "status")) === CupFileStatusComplete;
        }));
        ((___r1 = self.queue), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "removeObjectsAtIndexes:", indexes));
        ((___r1 = self.isa.objj_msgSend0(self, "queueController")), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "setContent:", self.queue));
    }
    var ___r1;
}
,["void"]), new objj_method(sel_getUid("fileInputDidSelectFiles:"), function $Cup__fileInputDidSelectFiles_(self, _cmd, files)
{
    if (self.delegateImplementsFlags & delegateChange)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:fileInputDidSelectFiles:", self, files));
    var ___r1;
}
,["void","CPArray"]), new objj_method(sel_getUid("filesWerePasted:"), function $Cup__filesWerePasted_(self, _cmd, files)
{
    if (self.delegateImplementsFlags & delegatePaste)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:didPasteFiles:", self, files));
    var ___r1;
}
,["void","CPArray"]), new objj_method(sel_getUid("filesWereDropped:"), function $Cup__filesWereDropped_(self, _cmd, files)
{
    if (self.delegateImplementsFlags & delegateDrop)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:didDropFiles:", self, files));
    var ___r1;
}
,["void","CPArray"]), new objj_method(sel_getUid("filesWereDraggedOverWithEvent:"), function $Cup__filesWereDraggedOverWithEvent_(self, _cmd, anEvent)
{
    if (self.delegateImplementsFlags & delegateDrag)
        ((___r1 = self.delegate), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "cup:wasDraggedOverWithEvent:", self, anEvent));
    var ___r1;
}
,["void","jQueryEvent"]), new objj_method(sel_getUid("_init"), function $Cup___init(self, _cmd)
{
    self.isa.objj_msgSend0(self, "makeFileInput");
    self.fileUploadOptions = {};
    self.delegateImplementsFlags = 0;
    self.fileClass = (CupFile == null ? null : CupFile.isa.objj_msgSend0(CupFile, "class"));
    self.isa.objj_msgSend0(self, "queueController");
    self.URL = self.URL || "";
    self.redirectURL = "";
    self.sequential = NO;
    self.maxConcurrentUploads = 0;
    self.maxChunkSize = 0;
    self.progressInterval = CupDefaultProgressInterval;
    self.progress = CPMutableDictionary.isa.objj_msgSend0(CPMutableDictionary, "dictionary");
    self.dropTarget = CPPlatformWindow.isa.objj_msgSend0(CPPlatformWindow, "primaryPlatformWindow");
    self.jQueryDropTarget = jQuery(document);
    self.removeCompletedFiles = NO;
    self.isa.objj_msgSend0(self, "resetProgress");
    self.isa.objj_msgSend1(self, "setUploading:", NO);
    self.isa.objj_msgSend1(self, "setIndeterminate:", !CPFeatureIsCompatible(CPFileAPIFeature));
    CPTimer.isa.objj_msgSend(CPTimer, "scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:", 0, self, sel_getUid("finishInit"), nil, NO);
}
,["void"]), new objj_method(sel_getUid("makeFileInput"), function $Cup__makeFileInput(self, _cmd)
{
    var input = nil;
    for (var counter = 1; ; ++counter)
    {
        self.widgetId = baseWidgetId + counter;
        input = document.getElementById(self.widgetId);
        if (!input)
            break;
    }
    var bodyElement = CPPlatform.isa.objj_msgSend0(CPPlatform, "mainBodyElement");
    input = document.createElement("input");
    input.className = "cpdontremove";
    input.setAttribute("type", "file");
    input.setAttribute("id", self.widgetId);
    input.setAttribute("name", "files[]");
    input.setAttribute("multiple", "");
    input.style.visibility = "hidden";
    bodyElement.appendChild(input);
}
,["void"]), new objj_method(sel_getUid("finishInit"), function $Cup__finishInit(self, _cmd)
{
    (jQuery("#" + self.widgetId)).fileupload(self.isa.objj_msgSend0(self, "makeOptions"));
}
,["void"]), new objj_method(sel_getUid("setCallbacks:"), function $Cup__setCallbacks_(self, _cmd, options)
{
    if (!self.callbacks)
    {
        self.callbacks = {add: function(e, data)
        {
            self.currentEvent = e;
            self.currentData = data;
            self.isa.objj_msgSend1(self, "addFile:", data.files[0]);
            self.isa.objj_msgSend0(self, "pumpRunLoop");
        }, submit: function(e, data)
        {
            self.currentEvent = e;
            self.currentData = data;
            var canSubmit = self.isa.objj_msgSend1(self, "submitFile:", self.isa.objj_msgSend1(self, "fileFromJSFile:", data.files[0]));
            self.isa.objj_msgSend0(self, "pumpRunLoop");
            return canSubmit;
        }, send: function(e, data)
        {
            self.currentEvent = e;
            self.currentData = data;
            var canSend = self.isa.objj_msgSend1(self, "willSendFile:", self.isa.objj_msgSend1(self, "fileFromJSFile:", data.files[0]));
            self.isa.objj_msgSend0(self, "pumpRunLoop");
            return canSend;
        }, done: function(e, data)
        {
            self.currentEvent = e;
            self.currentData = data;
            self.isa.objj_msgSend1(self, "uploadDidSucceedForFile:", self.isa.objj_msgSend1(self, "fileFromJSFile:", data.files[0]));
            self.isa.objj_msgSend0(self, "pumpRunLoop");
        }, fail: function(e, data)
        {
            self.currentEvent = e;
            self.currentData = data;
            self.isa.objj_msgSend1(self, "uploadDidFailForFile:", self.isa.objj_msgSend1(self, "fileFromJSFile:", data.files[0]));
            self.isa.objj_msgSend0(self, "pumpRunLoop");
        }, always: function(e, data)
        {
            self.currentEvent = e;
            self.currentData = data;
            self.isa.objj_msgSend1(self, "uploadDidCompleteForFile:", self.isa.objj_msgSend1(self, "fileFromJSFile:", data.files[0]));
            self.isa.objj_msgSend0(self, "pumpRunLoop");
        }, progress: function(e, data)
        {
            self.currentEvent = e;
            self.currentData = data;
            var fileProgress = {uploadedBytes: data.loaded, total: data.total, bitrate: data.bitrate};
            self.isa.objj_msgSend2(self, "uploadForFile:didProgress:", self.isa.objj_msgSend1(self, "fileFromJSFile:", data.files[0]), fileProgress);
            self.isa.objj_msgSend0(self, "pumpRunLoop");
        }, progressall: function(e, data)
        {
            self.currentEvent = e;
            self.currentData = data;
            var overallProgress = {uploadedBytes: data.loaded, total: data.total, bitrate: data.bitrate};
            self.isa.objj_msgSend1(self, "uploadsDidProgress:", overallProgress);
            self.isa.objj_msgSend0(self, "pumpRunLoop");
        }, start: function(e)
        {
            self.currentEvent = e;
            self.currentData = nil;
            self.isa.objj_msgSend0(self, "uploadDidStart");
            self.isa.objj_msgSend0(self, "pumpRunLoop");
        }, stop: function(e)
        {
            self.currentEvent = e;
            self.currentData = nil;
            self.isa.objj_msgSend0(self, "uploadDidStop");
            self.isa.objj_msgSend0(self, "pumpRunLoop");
        }, change: function(e, data)
        {
            self.currentEvent = e;
            self.currentData = data;
            self.isa.objj_msgSend1(self, "fileInputDidSelectFiles:", data.files);
            self.isa.objj_msgSend0(self, "pumpRunLoop");
        }, paste: function(e, data)
        {
            self.currentEvent = e;
            self.currentData = data;
            self.isa.objj_msgSend1(self, "filesWerePasted:", data.files);
            self.isa.objj_msgSend0(self, "pumpRunLoop");
        }, drop: function(e, data)
        {
            self.currentEvent = e;
            self.currentData = data;
            self.isa.objj_msgSend1(self, "filesWereDropped:", data.files);
            self.isa.objj_msgSend0(self, "pumpRunLoop");
        }, dragover: function(e)
        {
            self.currentEvent = e;
            self.currentData = nil;
            self.isa.objj_msgSend1(self, "filesWereDraggedOverWithEvent:", e);
            self.isa.objj_msgSend0(self, "pumpRunLoop");
        }, chunksend: function(e, data)
        {
            self.currentEvent = e;
            self.currentData = data;
            var canSend = self.isa.objj_msgSend1(self, "chunkWillSendForFile:", self.isa.objj_msgSend1(self, "fileFromJSFile:", data.files[0]));
            self.isa.objj_msgSend0(self, "pumpRunLoop");
            return canSend;
        }, chunkdone: function(e, data)
        {
            self.currentEvent = e;
            self.currentData = data;
            self.isa.objj_msgSend1(self, "chunkDidSucceedForFile:", self.isa.objj_msgSend1(self, "fileFromJSFile:", data.files[0]));
            self.isa.objj_msgSend0(self, "pumpRunLoop");
        }, chunkfail: function(e, data)
        {
            self.currentEvent = e;
            self.currentData = data;
            self.isa.objj_msgSend1(self, "chunkDidFailForFile:", self.isa.objj_msgSend1(self, "fileFromJSFile:", data.files[0]));
            self.isa.objj_msgSend0(self, "pumpRunLoop");
        }, chunkalways: function(e, data)
        {
            self.currentEvent = e;
            self.currentData = data;
            self.isa.objj_msgSend1(self, "chunkDidCompleteForFile:", self.isa.objj_msgSend1(self, "fileFromJSFile:", data.files[0]));
            self.isa.objj_msgSend0(self, "pumpRunLoop");
        }};
    }
    for (var key in self.callbacks)
        if (self.callbacks.hasOwnProperty(key))
            options[key] = self.callbacks[key];
}
,["void","JSObject"]), new objj_method(sel_getUid("_setFilenameFilter:caseSensitive:"), function $Cup___setFilenameFilter_caseSensitive_(self, _cmd, aFilter, caseSensitive)
{
    var regex = new RegExp(aFilter, caseSensitive ? "" : "i");
    if (regex.toString() === (self.filenameFilterRegex || "").toString())
        return;
    self.isa.objj_msgSend1(self, "willChangeValueForKey:", "filenameFilter");
    self.isa.objj_msgSend1(self, "willChangeValueForKey:", "filenameFilterRegex");
    self.filenameFilter = aFilter;
    self.filenameFilterRegex = aFilter ? regex : nil;
    self.isa.objj_msgSend1(self, "didChangeValueForKey:", "filenameFilterRegex");
    self.isa.objj_msgSend1(self, "didChangeValueForKey:", "filenameFilter");
}
,["void","CPString","BOOL"]), new objj_method(sel_getUid("pumpRunLoop"), function $Cup__pumpRunLoop(self, _cmd)
{
    ((___r1 = CPRunLoop.isa.objj_msgSend0(CPRunLoop, "currentRunLoop")), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "limitDateForMode:", CPDefaultRunLoopMode));
    var ___r1;
}
,["void"]), new objj_method(sel_getUid("fileFromJSFile:"), function $Cup__fileFromJSFile_(self, _cmd, file)
{
    return self.isa.objj_msgSend1(self, "fileWithUID:", file.CPUID);
}
,["CupFile","JSFile"]), new objj_method(sel_getUid("fileWithUID:"), function $Cup__fileWithUID_(self, _cmd, aUID)
{
    var index = ((___r1 = self.queue), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "indexOfObjectPassingTest:", function(file)
    {
        return (file == null ? null : file.isa.objj_msgSend0(file, "UID")) === aUID;
    }));
    return index >= 0 ? self.queue[index] : nil;
    var ___r1;
}
,["CupFile","CPString"]), new objj_method(sel_getUid("fileUpload:"), function $Cup__fileUpload_(self, _cmd, firstObject)
{
    var args = Array.prototype.slice.apply(arguments, [2]),
        widget = jQuery("#" + self.widgetId);
    if (args[0] !== nil)
        return widget.fileupload.apply(widget, args);
    else
        return widget.fileupload();
}
,["id","id"]), new objj_method(sel_getUid("makeOptions"), function $Cup__makeOptions(self, _cmd)
{
    self.fileUploadOptions["dataType"] = "json";
    self.fileUploadOptions["url"] = self.URL;
    self.fileUploadOptions["sequentialUploads"] = self.sequential;
    self.fileUploadOptions["maxChunkSize"] = self.maxChunkSize;
    self.fileUploadOptions["limitConcurrentUploads"] = self.maxConcurrentUploads;
    self.fileUploadOptions["progressInterval"] = self.progressInterval;
    self.fileUploadOptions["dropZone"] = self.jQueryDropTarget;
    self.isa.objj_msgSend1(self, "setCallbacks:", self.fileUploadOptions);
    return self.fileUploadOptions;
}
,["JSObject"]), new objj_method(sel_getUid("updateProgressWithUploadedBytes:total:percentComplete:bitrate:"), function $Cup__updateProgressWithUploadedBytes_total_percentComplete_bitrate_(self, _cmd, uploadedBytes, total, percentComplete, bitrate)
{
    if (uploadedBytes !== nil)
        ((___r1 = self.progress), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "setValue:forKey:", uploadedBytes, "uploadedBytes"));
    if (total !== nil)
        ((___r1 = self.progress), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "setValue:forKey:", total, "total"));
    if (percentComplete !== nil)
        ((___r1 = self.progress), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "setValue:forKey:", FLOOR(percentComplete), "percentComplete"));
    if (bitrate !== nil)
        ((___r1 = self.progress), ___r1 == null ? null : ___r1.isa.objj_msgSend2(___r1, "setValue:forKey:", bitrate, "bitrate"));
    var ___r1;
}
,["void","CPNumber","CPNumber","CPNumber","CPNumber"]), new objj_method(sel_getUid("resetProgress"), function $Cup__resetProgress(self, _cmd)
{
    self.isa.objj_msgSend(self, "updateProgressWithUploadedBytes:total:percentComplete:bitrate:", 0, self.isa.objj_msgSend0(self, "totalSizeOfQueue"), 0, 0);
}
,["void"]), new objj_method(sel_getUid("validateFile:"), function $Cup__validateFile_(self, _cmd, file)
{
    var flags = 0;
    if (self.filenameFilterRegex && !self.filenameFilterRegex.test(file.name))
        flags |= CupFilteredName;
    if (file.size != null && self.maxFileSize && file.size > self.maxFileSize)
        flags |= CupFilteredSize;
    return flags;
}
,["int","JSFile"]), new objj_method(sel_getUid("fileWasRejected:because:"), function $Cup__fileWasRejected_because_(self, _cmd, file, filterFlags)
{
    var error = CPString.isa.objj_msgSend2(CPString, "stringWithFormat:", "The file “%@” was rejected because the ", (file == null ? null : file.isa.objj_msgSend0(file, "name")));
    if (filterFlags & CupFilteredName)
        error += "filename did not match the filename filter.";
    if (filterFlags & CupFilteredSize)
    {
        if (filterFlags & CupFilteredName)
            error += " In addition, the ";
        var fileSize = CPNumberFormatter.isa.objj_msgSend2(CPNumberFormatter, "localizedStringFromNumber:numberStyle:", (file == null ? null : file.isa.objj_msgSend0(file, "size")), CPNumberFormatterDecimalStyle),
            maxSize = CPNumberFormatter.isa.objj_msgSend2(CPNumberFormatter, "localizedStringFromNumber:numberStyle:", self.maxFileSize, CPNumberFormatterDecimalStyle);
        error += CPString.isa.objj_msgSend3(CPString, "stringWithFormat:", "size (%s bytes) is larger than the maximum file size (%s bytes).", fileSize, maxSize);
    }
    ((___r1 = CPAlert.isa.objj_msgSend(CPAlert, "alertWithMessageText:defaultButton:alternateButton:otherButton:informativeTextWithFormat:", error, "OK", nil, nil, "")), ___r1 == null ? null : ___r1.isa.objj_msgSend0(___r1, "runModal"));
    var ___r1;
}
,["void","CupFile","int"]), new objj_method(sel_getUid("totalSizeOfQueue"), function $Cup__totalSizeOfQueue(self, _cmd)
{
    var total = 0,
        count = ((___r1 = self.queue), ___r1 == null ? null : ___r1.isa.objj_msgSend0(___r1, "count"));
    while (count--)
        total += ((___r1 = self.queue[count]), ___r1 == null ? null : ___r1.isa.objj_msgSend0(___r1, "size"));
    return total;
    var ___r1;
}
,["int"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("automaticallyNotifiesObserversForKey:"), function $Cup__automaticallyNotifiesObserversForKey_(self, _cmd, key)
{
    if (key === "filenameFilter" || key === "filenameFilterRegex")
        return NO;
    else
        return objj_msgSendSuper({ receiver:self, super_class:objj_getMetaClass("Cup").super_class }, "automaticallyNotifiesObserversForKey:", key);
}
,["BOOL","CPString"]), new objj_method(sel_getUid("versionString"), function $Cup__versionString(self, _cmd)
{
    var bundle = CPBundle.isa.objj_msgSend1(CPBundle, "bundleForClass:", self.isa.objj_msgSend0(self, "class"));
    return (bundle == null ? null : bundle.isa.objj_msgSend1(bundle, "objectForInfoDictionaryKey:", "CPBundleVersion"));
}
,["CPString"])]);
}{var the_class = objj_allocateClassPair(CPObject, "CupFile"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("cup"), new objj_ivar("name"), new objj_ivar("size"), new objj_ivar("type"), new objj_ivar("status"), new objj_ivar("uploading"), new objj_ivar("uploadedBytes"), new objj_ivar("bitrate"), new objj_ivar("indeterminate"), new objj_ivar("data")]);objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("name"), function $CupFile__name(self, _cmd)
{
    return self.name;
}
,["CPString"]), new objj_method(sel_getUid("size"), function $CupFile__size(self, _cmd)
{
    return self.size;
}
,["int"]), new objj_method(sel_getUid("type"), function $CupFile__type(self, _cmd)
{
    return self.type;
}
,["CPString"]), new objj_method(sel_getUid("status"), function $CupFile__status(self, _cmd)
{
    return self.status;
}
,["int"]), new objj_method(sel_getUid("setStatus:"), function $CupFile__setStatus_(self, _cmd, newValue)
{
    self.status = newValue;
}
,["void","int"]), new objj_method(sel_getUid("uploading"), function $CupFile__uploading(self, _cmd)
{
    return self.uploading;
}
,["BOOL"]), new objj_method(sel_getUid("setUploading:"), function $CupFile__setUploading_(self, _cmd, newValue)
{
    self.uploading = newValue;
}
,["void","BOOL"]), new objj_method(sel_getUid("uploadedBytes"), function $CupFile__uploadedBytes(self, _cmd)
{
    return self.uploadedBytes;
}
,["int"]), new objj_method(sel_getUid("setUploadedBytes:"), function $CupFile__setUploadedBytes_(self, _cmd, newValue)
{
    self.uploadedBytes = newValue;
}
,["void","int"]), new objj_method(sel_getUid("bitrate"), function $CupFile__bitrate(self, _cmd)
{
    return self.bitrate;
}
,["float"]), new objj_method(sel_getUid("setBitrate:"), function $CupFile__setBitrate_(self, _cmd, newValue)
{
    self.bitrate = newValue;
}
,["void","float"]), new objj_method(sel_getUid("indeterminate"), function $CupFile__indeterminate(self, _cmd)
{
    return self.indeterminate;
}
,["BOOL"]), new objj_method(sel_getUid("data"), function $CupFile__data(self, _cmd)
{
    return self.data;
}
,["JSObject"]), new objj_method(sel_getUid("setData:"), function $CupFile__setData_(self, _cmd, newValue)
{
    self.data = newValue;
}
,["void","JSObject"]), new objj_method(sel_getUid("initWithCup:file:data:"), function $CupFile__initWithCup_file_data_(self, _cmd, aCup, file, someData)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CupFile").super_class }, "init"))
    {
        file.CPUID = (self == null ? null : self.isa.objj_msgSend0(self, "UID"));
        self.cup = aCup;
        self.name = file.name;
        self.status = CupFileStatusPending;
        self.uploading = NO;
        self.bitrate = 0.0;
        self.data = someData;
        if (file.size != null)
        {
            self.size = file.size;
            self.type = file.type;
            self.indeterminate = NO;
        }
        else
        {
            self.size = 0;
            self.type = "";
            self.indeterminate = YES;
        }
    }
    return self;
}
,["id","Cup","JSObject","JSObject"]), new objj_method(sel_getUid("percentComplete"), function $CupFile__percentComplete(self, _cmd)
{
    return self.indeterminate ? 0 : FLOOR(self.uploadedBytes / self.size * 100);
}
,["int"]), new objj_method(sel_getUid("submit"), function $CupFile__submit(self, _cmd)
{
    self.isa.objj_msgSend1(self, "setStatus:", CupFileStatusUploading);
    self.isa.objj_msgSend1(self, "setUploadedBytes:", 0);
    self.data.submit();
}
,["void"]), new objj_method(sel_getUid("start"), function $CupFile__start(self, _cmd)
{
    self.isa.objj_msgSend1(self, "setUploading:", YES);
}
,["void"]), new objj_method(sel_getUid("stop"), function $CupFile__stop(self, _cmd)
{
    self.isa.objj_msgSend1(self, "setStatus:", CupFileStatusPending);
    self.isa.objj_msgSend1(self, "setUploading:", NO);
    self.data.abort();
    ((___r1 = self.cup), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "uploadWasStoppedForFile:", self));
    var ___r1;
}
,["void"]), new objj_method(sel_getUid("description"), function $CupFile__description(self, _cmd)
{
    return CPString.isa.objj_msgSend(CPString, "stringWithFormat:", "%@ \"%@\", size=%d, type=%s, uploadedBytes=%d, status=%s", objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CupFile").super_class }, "description"), self.name, self.size, self.type, self.uploadedBytes, FileStatuses[self.status]);
}
,["CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("initialize"), function $CupFile__initialize(self, _cmd)
{
    if (self !== CupFile.isa.objj_msgSend0(CupFile, "class"))
        return;
    FileStatuses[CupFileStatusPending] = "Pending";
    FileStatuses[CupFileStatusUploading] = "Uploading";
    FileStatuses[CupFileStatusComplete] = "Complete";
}
,["void"]), new objj_method(sel_getUid("keyPathsForValuesAffectingPercentComplete"), function $CupFile__keyPathsForValuesAffectingPercentComplete(self, _cmd)
{
    return CPSet.isa.objj_msgSend1(CPSet, "setWithObjects:", "uploadedBytes");
}
,["CPSet"])]);
}{var the_class = objj_allocateClassPair(CPTableCellView, "CupTableCellView"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("stopUpload:"), function $CupTableCellView__stopUpload_(self, _cmd, sender)
{
    ((___r1 = self.isa.objj_msgSend0(self, "objectValue")), ___r1 == null ? null : ___r1.isa.objj_msgSend0(___r1, "stop"));
    var ___r1;
}
,["void","id"])]);
}var cloneOptions = function(options)
{
    var clone = {};
    for (var key in options)
        if (options.hasOwnProperty(key))
            if (typeof options[key] === "function")
                continue;
            else
                clone[key] = options[key];
    return clone;
};
p;25;CupByteCountTransformer.jt;3122;@STATIC;1.0;I;33;Foundation/CPByteCountFormatter.jI;31;Foundation/CPValueTransformer.jt;3029;objj_executeFile("Foundation/CPByteCountFormatter.j", NO);objj_executeFile("Foundation/CPValueTransformer.j", NO);var CupByteCountTransformerSharedFormatter = nil;
{var the_class = objj_allocateClassPair(CPValueTransformer, "CupByteCountTransformer"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("valueFormatter")]);objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("formatter"), function $CupByteCountTransformer__formatter(self, _cmd)
{
    if (!self.valueFormatter)
        self.valueFormatter = CPByteCountFormatter.isa.objj_msgSend0(CPByteCountFormatter, "new");
    return self.valueFormatter;
}
,["CPByteCountFormatter"]), new objj_method(sel_getUid("setFormatter:"), function $CupByteCountTransformer__setFormatter_(self, _cmd, aFormatter)
{
    self.valueFormatter = aFormatter;
}
,["void","CPByteCountFormatter"]), new objj_method(sel_getUid("transformedValue:"), function $CupByteCountTransformer__transformedValue_(self, _cmd, value)
{
    value = value === nil ? 0 : value;
    return ((___r1 = self.valueFormatter ? self.valueFormatter : CupByteCountTransformerSharedFormatter), ___r1 == null ? null : ___r1.isa.objj_msgSend1(___r1, "stringFromByteCount:", value));
    var ___r1;
}
,["id","id"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("initialize"), function $CupByteCountTransformer__initialize(self, _cmd)
{
    if (self !== CupByteCountTransformer)
        return;
    CPValueTransformer.isa.objj_msgSend2(CPValueTransformer, "setValueTransformer:forName:", self.isa.objj_msgSend0(self, "new"), "CupByteCountTransformer");
    CupByteCountTransformerSharedFormatter = self.isa.objj_msgSend0(self, "makeFormatter");
}
,["void"]), new objj_method(sel_getUid("makeFormatter"), function $CupByteCountTransformer__makeFormatter(self, _cmd)
{
    var formatter = CPByteCountFormatter.isa.objj_msgSend0(CPByteCountFormatter, "new");
    (formatter == null ? null : formatter.isa.objj_msgSend1(formatter, "setAdaptive:", YES));
    (formatter == null ? null : formatter.isa.objj_msgSend1(formatter, "setAllowedUnits:", CPByteCountFormatterUseKB | CPByteCountFormatterUseMB | CPByteCountFormatterUseGB));
    (formatter == null ? null : formatter.isa.objj_msgSend1(formatter, "setAllowsNonnumericFormatting:", NO));
    (formatter == null ? null : formatter.isa.objj_msgSend1(formatter, "setZeroPadsFractionDigits:", YES));
    return formatter;
}
,["CPByteCountFormatter"]), new objj_method(sel_getUid("sharedFormatter"), function $CupByteCountTransformer__sharedFormatter(self, _cmd)
{
    return CupByteCountTransformerSharedFormatter;
}
,["CPByteCountFormatter"]), new objj_method(sel_getUid("transformedValueClass"), function $CupByteCountTransformer__transformedValueClass(self, _cmd)
{
    return CPString.isa.objj_msgSend0(CPString, "class");
}
,["Class"]), new objj_method(sel_getUid("allowsReverseTransformation"), function $CupByteCountTransformer__allowsReverseTransformation(self, _cmd)
{
    return NO;
}
,["BOOL"])]);
}p;13;CupDelegate.jt;4040;@STATIC;1.0;I;21;Foundation/CPObject.ji;5;Cup.jt;3986;objj_executeFile("Foundation/CPObject.j", NO);objj_executeFile("Cup.j", YES);{var the_class = objj_allocateClassPair(CPObject, "CupDelegate"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("cup:didFilterFile:because:"), function $CupDelegate__cup_didFilterFile_because_(self, _cmd, cup, file, filterFlags)
{
}
,["void","Cup","CupFile","int"]), new objj_method(sel_getUid("cup:willAddFile:"), function $CupDelegate__cup_willAddFile_(self, _cmd, cup, file)
{
    return YES;
}
,["BOOL","Cup","CupFile"]), new objj_method(sel_getUid("cup:didAddFile:"), function $CupDelegate__cup_didAddFile_(self, _cmd, cup, file)
{
}
,["void","Cup","CupFile"]), new objj_method(sel_getUid("cupDidStart:"), function $CupDelegate__cupDidStart_(self, _cmd, cup)
{
}
,["void","Cup"]), new objj_method(sel_getUid("cup:willSubmitFile:"), function $CupDelegate__cup_willSubmitFile_(self, _cmd, cup, file)
{
    return YES;
}
,["BOOL","Cup","CupFile"]), new objj_method(sel_getUid("cup:willSendFile:"), function $CupDelegate__cup_willSendFile_(self, _cmd, cup, file)
{
    return YES;
}
,["BOOL","Cup","CupFile"]), new objj_method(sel_getUid("cup:willSendChunkForFile:"), function $CupDelegate__cup_willSendChunkForFile_(self, _cmd, cup, file)
{
    return YES;
}
,["BOOL","Cup","CupFile"]), new objj_method(sel_getUid("cup:chunkDidSucceedForFile:"), function $CupDelegate__cup_chunkDidSucceedForFile_(self, _cmd, cup, file)
{
}
,["void","Cup","CupFile"]), new objj_method(sel_getUid("cup:chunkDidFailForFile:"), function $CupDelegate__cup_chunkDidFailForFile_(self, _cmd, cup, file)
{
}
,["void","Cup","CupFile"]), new objj_method(sel_getUid("cup:chunkDidCompleteForFile:"), function $CupDelegate__cup_chunkDidCompleteForFile_(self, _cmd, cup, file)
{
}
,["void","Cup","CupFile"]), new objj_method(sel_getUid("cup:uploadForFile:didProgress:"), function $CupDelegate__cup_uploadForFile_didProgress_(self, _cmd, cup, file, progress)
{
}
,["void","Cup","CupFile","JSObject"]), new objj_method(sel_getUid("cup:uploadsDidProgress:"), function $CupDelegate__cup_uploadsDidProgress_(self, _cmd, cup, progress)
{
}
,["void","Cup","JSObject"]), new objj_method(sel_getUid("cup:uploadDidSucceedForFile:"), function $CupDelegate__cup_uploadDidSucceedForFile_(self, _cmd, cup, file)
{
}
,["void","Cup","CupFile"]), new objj_method(sel_getUid("cup:uploadDidFailForFile:"), function $CupDelegate__cup_uploadDidFailForFile_(self, _cmd, cup, file)
{
}
,["void","Cup","CupFile"]), new objj_method(sel_getUid("cup:uploadDidCompleteForFile:"), function $CupDelegate__cup_uploadDidCompleteForFile_(self, _cmd, cup, file)
{
}
,["void","Cup","CupFile"]), new objj_method(sel_getUid("cup:uploadWasStoppedForFile:"), function $CupDelegate__cup_uploadWasStoppedForFile_(self, _cmd, cup, file)
{
}
,["void","Cup","CupFile"]), new objj_method(sel_getUid("cupDidStop:"), function $CupDelegate__cupDidStop_(self, _cmd, cup)
{
}
,["void","Cup"]), new objj_method(sel_getUid("cup:fileInputDidSelectFiles:"), function $CupDelegate__cup_fileInputDidSelectFiles_(self, _cmd, cup, files)
{
}
,["void","Cup","CPArray"]), new objj_method(sel_getUid("cupDidStartQueue:"), function $CupDelegate__cupDidStartQueue_(self, _cmd, cup)
{
}
,["void","Cup"]), new objj_method(sel_getUid("cupDidClearQueue:"), function $CupDelegate__cupDidClearQueue_(self, _cmd, cup)
{
}
,["void","Cup"]), new objj_method(sel_getUid("cupDidStopQueue:"), function $CupDelegate__cupDidStopQueue_(self, _cmd, cup)
{
}
,["void","Cup"]), new objj_method(sel_getUid("cup:didPasteFiles:"), function $CupDelegate__cup_didPasteFiles_(self, _cmd, cup, files)
{
}
,["void","Cup","CPArray"]), new objj_method(sel_getUid("cup:didDropFiles:"), function $CupDelegate__cup_didDropFiles_(self, _cmd, cup, files)
{
}
,["void","Cup","CPArray"]), new objj_method(sel_getUid("cup:wasDraggedOverWithEvent:"), function $CupDelegate__cup_wasDraggedOverWithEvent_(self, _cmd, cup, event)
{
}
,["void","Cup","jQueryEvent"])]);
}e;