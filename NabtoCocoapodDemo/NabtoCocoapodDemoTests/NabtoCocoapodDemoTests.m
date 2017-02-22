//
//  NabtoCocoapodDemoTests.m
//  NabtoCocoapodDemoTests
//
//  Created by Nabto on 2/22/17.
//  Copyright © 2017 Nabto. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NabtoClient/NabtoClient.h"

#define TEST_DEVICE_INTERFACE_XML \
       "<unabto_queries>" \
       "  <query name='wind_speed.json' id='2'>" \
       "    <request></request>" \
       "    <response format='json'>" \
       "      <parameter name='rpc_speed_m_s' type='uint32'/>" \
       "    </response>" \
       "  </query>" \
       "</unabto_queries>"

@interface NabtoCocoapodDemoTests : XCTestCase

@end

@implementation NabtoCocoapodDemoTests

- (void)testObjCWrapper {
    XCTAssertEqual([[NabtoClient instance] nabtoStartup], NABTO_OK);
    XCTAssertEqual([[NabtoClient instance] nabtoOpenSessionGuest], NABTO_OK);
    char* errorMsg;
    XCTAssertEqual([[NabtoClient instance] nabtoRpcSetDefaultInterface:@(TEST_DEVICE_INTERFACE_XML)
                                                      withErrorMessage:&errorMsg],NABTO_OK);
    
    char* json;
    XCTAssertEqual([[NabtoClient instance] nabtoRpcInvoke:@"nabto://demo.nabto.net/wind_speed.json?"
                                         withResultBuffer:&json], NABTO_OK);
    NSLog(@"rpcInvoke from docs finished with result: %s", json);
    nabtoFree(json);
    
    XCTAssertEqual([[NabtoClient instance] nabtoShutdown], NABTO_OK);
}

- (void)testNativeSdk {
    XCTAssertEqual(nabtoStartup(NULL), NABTO_OK);
    nabto_handle_t session;
    XCTAssertEqual(nabtoOpenSession(&session, "guest", "123456"), NABTO_OK);
    char* error;
    XCTAssertEqual(nabtoRpcSetDefaultInterface(session, TEST_DEVICE_INTERFACE_XML, &error), NABTO_OK);

    char* result;
    XCTAssertEqual(nabtoRpcInvoke(session, "nabto://demo.nabto.net/wind_speed.json?", &result), NABTO_OK);
    NSLog(@"fetchUrl finished with result: %s", result);
    NSString* str = @(result);
    nabtoFree(result);
    XCTAssertTrue([str containsString:@"rpc_speed_m_s"]);
}

@end
