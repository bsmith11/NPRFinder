//
//  NPRNetworkConstants.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRNetworkConstants.h"

#pragma mark - Base URL

NSString * const kNPRBaseUrl = @"http://api.npr.org/";

#pragma mark - Routes

NSString * const kNPRRouteStations = @"v2/stations/";
NSString * const kNPRRouteProgramsList = @"/list/";

#pragma mark - Request

NSString * const kNPRRequestKeyApiKey = @"apiKey";
NSString * const kNPRRequestKeyId = @"id";
NSString * const kNPRRequestKeyOrganizationId = @"orgId";
NSString * const kNPRRequestKeyOutput = @"output";

NSString * const kNPRRequestValueId = @"3004";
NSString * const kNPRRequestValueOutput = @"JSON";

#pragma mark - Station

NSString * const kNPRResponseKeyStationGUID = @"guid";
NSString * const kNPRResponseKeyStationOrganizationId = @"org_id";
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
NSString * const kNPRResponseKeyStationUrls = @"urls";
NSString * const kNPRResponseKeyStationHomepage = @"homepage";
NSString * const kNPRResponseKeyStationDonationUrl = @"donation_url";
NSString * const kNPRResponseKeyStationLogo = @"logo";

#pragma mark - Station URL

NSString * const kNPRResponseKeyStationUrlTypeId = @"type_id";
NSString * const kNPRResponseKeyStationUrlTypeName = @"type_name";
NSString * const kNPRResponseKeyStationUrlTitle = @"title";
NSString * const kNPRResponseKeyStationUrlHREF = @"href";

#pragma mark - Program

NSString * const kNPRResponseKeyProgramItem = @"item";
NSString * const kNPRResponseKeyProgramAdditionalInfo = @"additionalInfo";
NSString * const kNPRResponseKeyProgramId = @"id";
NSString * const kNPRResponseKeyProgramNum = @"num";
NSString * const kNPRResponseKeyProgramTitle = @"title";
NSString * const kNPRResponseKeyProgramType = @"type";
NSString * const kNPRResponseKeyProgramText = @"$text";
