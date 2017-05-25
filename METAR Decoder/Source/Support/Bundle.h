//
//  Bundle.h
//  METAR Decoder
//
//  Created by Tim Morgan on 7/19/17.
//  Copyright © 2017 Tim Morgan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bundle : NSObject {
    @private
    NSBundle *bundle;
}

+ (Bundle * _Nonnull) shared;

- (NSString * _Nullable) localizedStringForKey:(nullable NSString *)key;

@end

#define MDLocalizedString(key, comment) [[Bundle shared] localizedStringForKey:(key)]
