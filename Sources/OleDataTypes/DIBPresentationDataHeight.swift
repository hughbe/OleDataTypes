//
//  DIBPresentationDataHeight.swift
//
//
//  Created by Hugh Bellamy on 25/11/2020.
//

/// [MS-OLEDS] 2.1.13 DIBPresentationDataHeight
/// This MUST be a long value that contains the height of a Device Independent Bitmap object (as specified in [MS-WMF] section 2.2.2.9) in
/// logical units. The MM_HIMETRIC mapping mode (as specified in [MS-WMF] section 2.1.1.16) MUST be used to convert the logical units
/// to physical units.
public typealias DIBPresentationDataHeight = Int32
