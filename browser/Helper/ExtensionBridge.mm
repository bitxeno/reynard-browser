//
//  ExtensionBridge.mm
//  Reynard
//
//  Created by Minh Ton on 20/2/26.
//

#import "ExtensionBridge.h"

#if !(defined(TARGET_OS_TV) && TARGET_OS_TV)
@interface NSXPCConnection (Private)
- (xpc_connection_t _Nullable)_xpcConnection;
@end
#endif

xpc_connection_t _Nullable XPCConnectionFromNSXPC(
    NSXPCConnection *_Nonnull aConnection) {
#if defined(TARGET_OS_TV) && TARGET_OS_TV
  return nil;
#else
  if (![aConnection respondsToSelector:@selector(_xpcConnection)]) {
    return nil;
  }
  return [aConnection _xpcConnection];
#endif
}
