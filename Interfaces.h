//
//  Interfaces.h
//  GhostBuster
//
//  Created by Tanner Bennett on 2017-06-26
//  Copyright © 2017 Tanner Bennett. All rights reserved.
//

#pragma mark Imports




#pragma mark Interfaces

@interface FBApplicationInfo : NSObject
@property NSString *displayName;
@property NSString *bundleIdentifier;
@property NSDictionary *environmentVariables;
@end


#pragma mark Macros

#define Hake(name) \
    (void *)&$ ## name, (void **) &_ ## name

// Use with MSHook(ret, sym, args) where func is sym
// MSHake = $foo, _foo
// $foo = replaced
// _foo = orig
#define MSSetHook(func) MSHookFunction(func, Hake(func))

// Use like MSSetHook, but dynamically loads the symbol for you.
#ifdef _DLFCN_H_
#define dlhook(name) \
    void * name = dlsym(dlopen(NULL, 0x2), #name); \
    MSSetHook(name);
#else
//#warning Add "#include <dlfcn.h>"
#endif

// Example:

// MSHook(ReturnType, PrivateFunc, T arg1, U arg2) {
//     // %orig(arg1, arg2)
//     id ret = _PrivateFunc(arg1, arg2)
//     ...
//     return ret
// }
// 
// %ctor {
//     dlhook(PrivateFunc);
// }

/// ie PropertyForKey(dateLabel, UILabel *, UITableViewCell)
#define PropertyForKey(key, propertyType, class) \
@interface class (key) @property (readonly) propertyType key; @end \
@implementation class (key) - (propertyType)key { return [self valueForKey:@"_"@#key]; } @end

#define RWPropertyInf(key, propertyType, class) \
@interface class (key) @property propertyType key; @end

#define Alert(TITLE,MSG) [[[UIAlertView alloc] initWithTitle:(TITLE) \
message:(MSG) \
delegate:nil \
cancelButtonTitle:@"OK" \
otherButtonTitles:nil] show];

#define UIAlertController(title, msg) [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:1]
#define UIAlertControllerAddAction(alert, title, stl, code...) [alert addAction:[UIAlertAction actionWithTitle:title style:stl handler:^(id action) code]];
#define UIAlertControllerAddCancel(alert) [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]
#define ShowAlertController(alert, from) [from presentViewController:alert animated:YES completion:nil];
