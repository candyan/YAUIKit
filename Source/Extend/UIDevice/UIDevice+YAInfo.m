//
//  UIDevice+YAInfo.m
//  YAUIKit
//
//  Created by candyan on 12/18/15.
//  Copyright © 2015 YAUIKit. All rights reserved.
//

#import "UIDevice+YAInfo.h"
#import <sys/utsname.h>

@implementation UIDevice (YAInfo)

- (NSString *)ya_modelName
{
    struct utsname systemInfo;

    uname(&systemInfo);

    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    static NSDictionary *deviceNamesByCode = nil;

    if (!deviceNamesByCode) {

        deviceNamesByCode = @{
            @"i386" : @"Simulator",
            @"x86_64" : @"Simulator",
            @"iPod1,1" : @"iPod Touch",   // (Original)
            @"iPod2,1" : @"iPod Touch 2", // (Second Generation)
            @"iPod3,1" : @"iPod Touch 3", // (Third Generation)
            @"iPod4,1" : @"iPod Touch 4", // (Fourth Generation)
            @"iPod5,1" : @"iPod Touch 5", // (Fifth Generation)
            @"iPod6,1" : @"iPod Touch 6", // (Sixth Generation)
            @"iPad1,1" : @"iPad",         // (Original)
            @"iPad1,2" : @"iPad",         // (Original 3G)
            @"iPad2,1" : @"iPad 2",       // (2nd Generation)
            @"iPad2,2" : @"iPad 2",       // (2nd Generation)
            @"iPad2,3" : @"iPad 2",       // (2nd Generation)
            @"iPad2,4" : @"iPad 2",       // (2nd Generation)
            @"iPad2,5" : @"iPad Mini",    // (Original)
            @"iPad2,6" : @"iPad Mini",    // (Original)
            @"iPad2,7" : @"iPad Mini",    // (Original)
            @"iPad3,1" : @"iPad 3",       // (3rd Generation)
            @"iPad3,2" : @"iPad 3",       // (3rd Generation)
            @"iPad3,3" : @"iPad 3",       // (3rd Generation)
            @"iPad3,4" : @"iPad 4",       // (4th Generation)
            @"iPad3,5" : @"iPad 4",       // (4th Generation)
            @"iPad3,6" : @"iPad 4",       // (4th Generation)
            @"iPad4,1" : @"iPad Air",     // 5th Generation iPad (iPad Air) - Wifi
            @"iPad4,2" : @"iPad Air",     // 5th Generation iPad (iPad Air) - Cellular GSM
            @"iPad4,3" : @"iPad Air",     // 5th Generation iPad (iPad Air) - Cellular CDMA
            @"iPad4,4" : @"iPad Mini 2",  // (2nd Generation iPad Mini - Wifi)
            @"iPad4,5" : @"iPad Mini 2",  // (2nd Generation iPad Mini - Cellular CDMA)
            @"iPad4,6" : @"iPad Mini 2",  // (2nd Generation iPad Mini - Cellular CN)
            @"iPad4,7" : @"iPad Mini 3",  // (3rd Generation iPad Mini - Cellular CN)
            @"iPad4,8" : @"iPad Mini 3",  // (3rd Generation iPad Mini - Cellular CN)
            @"iPad5,3" : @"iPad Air 2",   // (2nd Generation iPad Air - Cellular CN)
            @"iPad5,4" : @"iPad Air 2",   // (2nd Generation iPad Air - Cellular CN)
            @"iPad6,8" : @"iPad Pro",
            @"iPhone1,1" : @"iPhone",             // (Original)
            @"iPhone1,2" : @"iPhone 3G",          // (3G)
            @"iPhone2,1" : @"iPhone 3GS",         // (3GS)
            @"iPhone3,1" : @"iPhone 4",           // (GSM)
            @"iPhone3,2" : @"iPhone 4",           // (GSM)
            @"iPhone3,3" : @"iPhone 4",           // (CDMA/Verizon/Sprint)
            @"iPhone4,1" : @"iPhone 4S",          //
            @"iPhone5,1" : @"iPhone 5",           // (model A1428, AT&T/Canada)
            @"iPhone5,2" : @"iPhone 5",           // (model A1429, everything else)
            @"iPhone5,3" : @"iPhone 5c",          // (model A1456, A1532 | GSM)
            @"iPhone5,4" : @"iPhone 5c",          // (model A1507, A1516, A1526 (China), A1529 | Global)
            @"iPhone6,1" : @"iPhone 5s",          // (model A1433, A1533 | GSM)
            @"iPhone6,2" : @"iPhone 5s",          // (model A1457, A1518, A1528 (China), A1530 | Global)
            @"iPhone7,1" : @"iPhone 6 Plus",      //
            @"iPhone7,2" : @"iPhone 6",           //
            @"iPhone8,1" : @"iPhone 6s",          //
            @"iPhone8,2" : @"iPhone 6s Plus",     //
            @"AppleTV2,1" : @"Apple TV 2G",       //
            @"AppleTV3,1" : @"Apple TV 3",        //
            @"AppleTV3,2" : @"Apple TV 3 (2013)", //
        };
    }

    NSString *deviceName = [deviceNamesByCode objectForKey:code];

    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:

        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if ([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if ([code rangeOfString:@"iPhone"].location != NSNotFound) {
            deviceName = @"iPhone";
        }
    }

    return deviceName;
}

@end
