#import "ViewController.h"
#import "NabtoClient/NabtoClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NabtoClient instance] nabtoStartup];
    [[NabtoClient instance] nabtoOpenSessionGuest];
    NSString* interfaceXml = @"<unabto_queries><query name='wind_speed.json' id='2'><request></request><response format='json'><parameter name='rpc_speed_m_s' type='uint32'/></response></query></unabto_queries>";
    
    char* errorMsg;
    if ([[NabtoClient instance] nabtoRpcSetDefaultInterface:interfaceXml withErrorMessage:&errorMsg] != NCS_OK) {
        // handle error
    }
    
    char* json;
    NabtoClientStatus status = [[NabtoClient instance] nabtoRpcInvoke:@"nabto://demo.nabto.net/wind_speed.json?" withResultBuffer:&json];
    if (status == NCS_OK) {
        NSLog(@"Nabto %@ rpcInvoke finished with result: %s", [[NabtoClient instance] nabtoVersionString], json);
        [[NabtoClient instance] nabtoFree:json];
    }
    NabtoTunnelHandle tunnel;
    NabtoTunnelState state;
    if ([[NabtoClient instance] nabtoTunnelOpenTcp:&tunnel toHost:@"streamdemo.nabto.net" onPort:80] == NCS_OK) {
        NSLog(@"Tunnel opened ok");
        [[NabtoClient instance] nabtoTunnelWait:tunnel pollPeriodMillis:10 timeoutMillis:5000 resultingState:&state];
        NSLog(@"Tunnel connection status is [%@]", [NabtoClient nabtoTunnelInfoString:state]);
    } else {
        NSLog(@"Tunnel could not be opened");
    }
    [[NabtoClient instance] nabtoShutdown];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
