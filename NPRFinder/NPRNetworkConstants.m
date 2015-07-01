//
//  NPRNetworkConstants.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRNetworkConstants.h"

#pragma mark - Base URL

NSString * const kNPRBaseURL = @"http://api.npr.org/";

#pragma mark - Routes

NSString * const kNPRRouteStations = @"v2/stations/search/";
NSString * const kNPRRouteProgramsList = @"/list/";

#pragma mark - Request

NSString * const kNPRRequestKeyAPIKey = @"apiKey";
NSString * const kNPRRequestKeyID = @"id";
NSString * const kNPRRequestKeyOrganizationID = @"orgId";
NSString * const kNPRRequestKeyOutput = @"output";

NSString * const kNPRRequestValueID = @"3004";
NSString * const kNPRRequestValueOutput = @"JSON";

#pragma mark - Station

NSString * const kNPRResponseKeyStationGUID = @"guid";
NSString * const kNPRResponseKeyStationOrganizationID = @"org_id";
NSString * const kNPRResponseKeyStationName = @"name";
NSString * const kNPRResponseKeyStationTitle = @"title";
NSString * const kNPRResponseKeyStationCall = @"call";
NSString * const kNPRResponseKeyStationFrequency = @"frequency";
NSString * const kNPRResponseKeyStationBand = @"band";
NSString * const kNPRResponseKeyStationTagline = @"tagline";
NSString * const kNPRResponseKeyStationAddress = @"address";
NSString * const kNPRResponseKeyStationMarketCity = @"market_city";
NSString * const kNPRResponseKeyStationMarketState = @"market_state";
NSString * const kNPRResponseKeyStationFormat = @"format";
NSString * const kNPRResponseKeyStationMusicOnly = @"music_only";
NSString * const kNPRResponseKeyStationStatus = @"status";
NSString * const kNPRResponseKeyStationEmail = @"email";
NSString * const kNPRResponseKeyStationAreaCode = @"area_code";
NSString * const kNPRResponseKeyStationPhone = @"phone";
NSString * const kNPRResponseKeyStationPhoneExtension = @"phone_extension";
NSString * const kNPRResponseKeyStationFax = @"fax";
NSString * const kNPRResponseKeyStationSignal = @"signal";
NSString * const kNPRResponseKeyStationSignalStrength = @"signal_strength";
NSString * const kNPRResponseKeyStationURLs = @"urls";
NSString * const kNPRResponseKeyStationHomepage = @"homepage";
NSString * const kNPRResponseKeyStationDonationURL = @"donation_url";
NSString * const kNPRResponseKeyStationLogo = @"logo";
NSString * const kNPRResponseKeyStationNetwork = @"network";
NSString * const kNPRResponseKeyStationStatusName = @"status_name";
NSString * const kNPRResponseKeyStationAbbreviation = @"abbreviation";

#pragma mark - Station URL

NSString * const kNPRResponseKeyStationURLTypeID = @"type_id";
NSString * const kNPRResponseKeyStationURLTypeName = @"type_name";
NSString * const kNPRResponseKeyStationURLTitle = @"title";
NSString * const kNPRResponseKeyStationURLHREF = @"href";
NSString * const kNPRResponseKeyStationURLStreamGUID = @"stream_guid";
NSString * const kNPRResponseKeyStationURLPrimaryStream = @"primary_stream";

#pragma mark - Program

NSString * const kNPRResponseKeyProgramItem = @"item";
NSString * const kNPRResponseKeyProgramAdditionalInfo = @"additionalInfo";
NSString * const kNPRResponseKeyProgramID = @"id";
NSString * const kNPRResponseKeyProgramNum = @"num";
NSString * const kNPRResponseKeyProgramTitle = @"title";
NSString * const kNPRResponseKeyProgramType = @"type";
NSString * const kNPRResponseKeyProgramText = @"$text";
