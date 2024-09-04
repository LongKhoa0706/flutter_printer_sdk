//
//  LogicM.h
//  flutter_printer_sdk
//
//  Created by Apple Mac mini intel on 2024/6/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogicM : NSObject

+ (int)posStatus:(NSData *)data;
+ (int)labelStatus:(NSData *)data;
+ (int)cashBoxStatus:(NSData *)data;

+ (NSData *)sendESC:(NSArray *)data;
+ (NSData *)sendTSPL:(NSArray *)data;
+ (NSData *)sendZPL:(NSArray *)data;

+ (int)retrunZPLBarCodeType:(NSString *)code;
+ (int)retrunZPLRotation:(NSString *)code;
+ (int)retrunZPLFontName:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
