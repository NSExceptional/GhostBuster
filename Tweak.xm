//
//  Tweak.xm
//  GhostBuster
//
//  Created by Tanner Bennett on 2017-06-26
//  Copyright © 2017 Tanner Bennett. All rights reserved.
//

#import "Interfaces.h"


%hook FBApplicationInfo

- (NSDictionary *)environmentVariables {
    NSMutableDictionary *environmentVariables = [%orig mutableCopy] ?: [NSMutableDictionary dictionary];
    
    // NSLog(@"***\nSnapchat env vars:\n%@\n\n***", environmentVariables);
    
    // If we're about to launch the Snapchat App
    // force dyld to load the tweaks listed below.
    if ([self.bundleIdentifier isEqualToString:@"com.toyopagroup.picaboo"]) {
        // Build list of additional tweaks to load
        NSArray *tweaksToLoad = @[@"FLEXing", @"Swizzle", @"SwipeExpander", @"SwipeSelection"];
        NSMutableString *toLoad = [NSMutableString string];
        for (NSString *tweak in tweaksToLoad) {
            [toLoad appendFormat:@":/Library/MobileSubstrate/DynamicLibraries/%@.dylib", tweak];
        }
        // Delete first ":"
        [toLoad deleteCharactersInRange:NSMakeRange(0, 1)];
        
        NSString *dyldLibrariresToLoad = environmentVariables[@"DYLD_INSERT_LIBRARIES"];
        if (dyldLibrariresToLoad.length) {     
            dyldLibrariresToLoad = [NSString stringWithFormat:@"%@:%@", dyldLibrariresToLoad, toLoad];
        } else {
            // Typically this code path will execute and Phantom's hook
            // will actually be the one calling our implementaiton, so
            // he will prepend "/usr/lib/libPh++.dylib:" to this string himself.
            dyldLibrariresToLoad = toLoad.copy;
        }
        
        environmentVariables[@"DYLD_INSERT_LIBRARIES"] = dyldLibrariresToLoad;
    }
    
    return environmentVariables;
}

%end
