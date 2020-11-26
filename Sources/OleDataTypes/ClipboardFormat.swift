//
//  File.swift
//  
//
//  Created by Hugh Bellamy on 25/11/2020.
//

/// [MS-OLEDS] 2.1.1 Clipboard Formats
/// Standard Clipboard Formats and Registered Clipboard Formats (see sections 1.3.5.1 and 1.7.1 for more details) are used to identify presentation
/// data formats.
/// A standard clipboard format identifier is of type unsigned long.
/// A registered clipboard format is identified by a LengthPrefixedAnsiString (section 2.1.4) or a LengthPrefixedUnicodeString (section 2.1.5).
/// The Object Linking and Embedding (OLE) Data Structures: Structure Specification defines the following standard clipboard format values to be used
/// to identify presentation data formats:
/// CF_BITMAP 0x00000002 Bitmap16 Object structure (as specified in [MS-WMF] section 2.2.2.1)
/// CF_METAFILEPICT 0x00000003 Windows metafile (as specified in [MS-WMF] section 1.3.1)
/// CF_DIB 0x00000008 DeviceIndependentBitmap Object structure (as specified in [MS-WMF] section 2.2.2.9)
/// CF_ENHMETAFILE 0x0000000E Enhanced Metafile (as specified in [MS-EMF] section 1.3.1)
/// In addition, an application or higher level protocol MAY supply registered clipboard formats (section 1.7.1) to identify custom presentation data formats.
public typealias ClipboardFormat = UInt32

/// CF_BITMAP 0x00000002 Bitmap16 Object structure (as specified in [MS-WMF] section 2.2.2.1)
public let CF_BITMAP: ClipboardFormat = 0x00000002

/// CF_METAFILEPICT 0x00000003 Windows metafile (as specified in [MS-WMF] section 1.3.1)
public let CF_METAFILEPICT: ClipboardFormat = 0x00000003

/// CF_DIB 0x00000008 DeviceIndependentBitmap Object structure (as specified in [MS-WMF] section 2.2.2.9)
public let CF_DIB: ClipboardFormat = 0x00000008

/// CF_ENHMETAFILE 0x0000000E Enhanced Metafile (as specified in [MS-EMF] section 1.3.1)
/// In addition, an application or higher level protocol MAY supply registered clipboard formats (section 1.7.1) to identify custom presentation data formats.
public let CF_ENHMETAFILE: ClipboardFormat = 0x0000000E
