//
//  Bundle.m
//  METAR Decoder
//
//  Created by Tim Morgan on 7/19/17.
//  Copyright © 2017 Tim Morgan. All rights reserved.
//

#import "Bundle.h"

@interface Bundle (Private)

- (void) load;

@end

@implementation Bundle

+ (id) shared {
    static Bundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [self new];
    });
    return bundle;
}

- (id) init {
    if (self = [super init]) {
        [self load];
    }
    return self;
}

- (NSString * _Nullable) localizedStringForKey:(nullable NSString *)key {
    NSBundle *localeBundle = [NSBundle bundleWithURL:[bundle URLForResource:@"en" withExtension:@"lproj"]];
    NSURL *stringsURL = [localeBundle URLForResource:@"Localizable" withExtension:@"strings"];
    NSDictionary *strings = [NSDictionary dictionaryWithContentsOfURL:stringsURL];
    return [strings objectForKey:key];
    //return [localeBundle localizedStringForKey:key value:@"" table:nil];
}

@end

@implementation Bundle (Private)

- (void) load {
    char cpath[1024];
    uint32_t size = sizeof(cpath);
    if (_NSGetExecutablePath(cpath, &size) == 0) {
        NSString *path = [[NSString alloc] initWithCString:cpath encoding:NSUTF8StringEncoding];
        NSString *bundlePath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"METAR Decoder Resources.bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
}

@end
