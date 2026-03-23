//
//  ExtensionBridge.h
//  Reynard
//
//  Created by Minh Ton on 20/2/26.
//

#ifndef ExtensionBridge_h
#define ExtensionBridge_h

#import <Foundation/Foundation.h>
#import <TargetConditionals.h>

#if defined(TARGET_OS_TV) && TARGET_OS_TV
typedef NSObject *xpc_connection_t;
#else
#import <xpc/xpc.h>
#endif

@class NSXPCConnection;

#ifdef __cplusplus
extern "C" {
#endif

xpc_connection_t _Nullable XPCConnectionFromNSXPC(
    NSXPCConnection *_Nonnull aConnection);

#ifdef __cplusplus
}
#endif

#endif /* ExtensionBridge_h */
