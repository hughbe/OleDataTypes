//
//  MetaFilePresentationDataHeight.swift
//
//
//  Created by Hugh Bellamy on 25/11/2020.
//

/// [MS-OLEDS] 2.1.9 MetaFilePresentationDataHeight
/// This MUST be a long value that contains the height of a metafile (as specified in [MS-WMF] section 1.3.1) in logical units. The
/// MM_ANISOTROPIC mapping mode (as specified in [MS-WMF] section 2.1.1.16) MUST be used to convert the logical units to physical units.
public typealias MetaFilePresentationDataHeight = Int32
