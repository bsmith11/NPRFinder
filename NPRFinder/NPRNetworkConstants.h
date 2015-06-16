//
//  NPRNetworkConstants.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Base URL

OBJC_EXTERN NSString * const kNPRBaseURL;

#pragma mark - Routes

OBJC_EXTERN NSString * const kNPRRouteStations;
OBJC_EXTERN NSString * const kNPRRouteProgramsList;

#pragma mark - Request

OBJC_EXTERN NSString * const kNPRRequestKeyAPIKey;
OBJC_EXTERN NSString * const kNPRRequestKeyID;
OBJC_EXTERN NSString * const kNPRRequestKeyOrganizationID;
OBJC_EXTERN NSString * const kNPRRequestKeyOutput;

OBJC_EXTERN NSString * const kNPRRequestValueID;
OBJC_EXTERN NSString * const kNPRRequestValueOutput;

#pragma mark - Station

OBJC_EXTERN NSString * const kNPRResponseKeyStationGUID;
OBJC_EXTERN NSString * const kNPRResponseKeyStationOrganizationID;
OBJC_EXTERN NSString * const kNPRResponseKeyStationName;
OBJC_EXTERN NSString * const kNPRResponseKeyStationTitle;
OBJC_EXTERN NSString * const kNPRResponseKeyStationCall;
OBJC_EXTERN NSString * const kNPRResponseKeyStationFrequency;
OBJC_EXTERN NSString * const kNPRResponseKeyStationBand;
OBJC_EXTERN NSString * const kNPRResponseKeyStationTagline;
OBJC_EXTERN NSString * const kNPRResponseKeyStationAddress;
OBJC_EXTERN NSString * const kNPRResponseKeyStationMarketCity;
OBJC_EXTERN NSString * const kNPRResponseKeyStationMarketState;
OBJC_EXTERN NSString * const kNPRResponseKeyStationFormat;
OBJC_EXTERN NSString * const kNPRResponseKeyStationMusicOnly;
OBJC_EXTERN NSString * const kNPRResponseKeyStationStatus;
OBJC_EXTERN NSString * const kNPRResponseKeyStationEmail;
OBJC_EXTERN NSString * const kNPRResponseKeyStationAreaCode;
OBJC_EXTERN NSString * const kNPRResponseKeyStationPhone;
OBJC_EXTERN NSString * const kNPRResponseKeyStationPhoneExtension;
OBJC_EXTERN NSString * const kNPRResponseKeyStationFax;
OBJC_EXTERN NSString * const kNPRResponseKeyStationSignal;
OBJC_EXTERN NSString * const kNPRResponseKeyStationSignalStrength;
OBJC_EXTERN NSString * const kNPRResponseKeyStationURLs;
OBJC_EXTERN NSString * const kNPRResponseKeyStationHomepage;
OBJC_EXTERN NSString * const kNPRResponseKeyStationDonationURL;
OBJC_EXTERN NSString * const kNPRResponseKeyStationLogo;
OBJC_EXTERN NSString * const kNPRResponseKeyStationNetwork;
OBJC_EXTERN NSString * const kNPRResponseKeyStationStatusName;
OBJC_EXTERN NSString * const kNPRResponseKeyStationAbbreviation;

#pragma mark - Station URL

OBJC_EXTERN NSString * const kNPRResponseKeyStationURLTypeID;
OBJC_EXTERN NSString * const kNPRResponseKeyStationURLTypeName;
OBJC_EXTERN NSString * const kNPRResponseKeyStationURLTitle;
OBJC_EXTERN NSString * const kNPRResponseKeyStationURLHREF;
OBJC_EXTERN NSString * const kNPRResponseKeyStationURLStreamGuid;
OBJC_EXTERN NSString * const kNPRResponseKeyStationURLPrimaryStream;

#pragma mark - Program

OBJC_EXTERN NSString * const kNPRResponseKeyProgramItem;
OBJC_EXTERN NSString * const kNPRResponseKeyProgramAdditionalInfo;
OBJC_EXTERN NSString * const kNPRResponseKeyProgramID;
OBJC_EXTERN NSString * const kNPRResponseKeyProgramNum;
OBJC_EXTERN NSString * const kNPRResponseKeyProgramTitle;
OBJC_EXTERN NSString * const kNPRResponseKeyProgramType;
OBJC_EXTERN NSString * const kNPRResponseKeyProgramText;

