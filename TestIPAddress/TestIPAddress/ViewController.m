//
//  ViewController.m
//  TestIPAddress
//
//  Created by Shrutesh Sharma on 19/02/13.
//  Copyright (c) 2013 Ninestars. All rights reserved.
//

#import "ViewController.h"

#import <ifaddrs.h>
#import <arpa/inet.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  //  NSLog(@"the ip address is %@",[self getIPAddress]);

    [self getIPAddress];
    
    
    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}





// Get IP Address
- (NSString *)getIPAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET ) { //|| sa_type == AF_INET6
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                
                [_ipLabel setText:addr]; //set the label

                
            NSArray* array = [addr componentsSeparatedByString: @"."];
            NSString* color = [array objectAtIndex: 0];
            NSString* color1 = [array objectAtIndex: 1];
            NSString* color2 = [array objectAtIndex: 2];
            NSString* color3 = [array objectAtIndex: 3];

                                
                int c  = [color intValue] ;
                int c1 = [color1 intValue];
                int c2 = [color2 intValue];
                int c3 = [color3 intValue];
                
                
                
                NSLog(@"color is %d", c);
                NSLog(@"color1 is %d",c1);
                NSLog(@"color2 is %d",c2);
                NSLog(@"color3 is %d",c3);


                [_view1 setBackgroundColor:[UIColor colorWithRed:c/255.0 green:c1/255.0 blue:c2/255.0 alpha:1]];
                [_view2 setBackgroundColor:[UIColor colorWithRed:c2/255.0 green:c3/255.0 blue:c/255.0 alpha:1]];
                [_view3 setBackgroundColor:[UIColor colorWithRed:c1/255.0 green:c2/255.0 blue:c/255.0 alpha:1]];
                [_view4 setBackgroundColor:[UIColor colorWithRed:c2/255.0 green:c/255.0 blue:c1/255.0 alpha:1]];
                
               

                             
                if([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else
                    if([name isEqualToString:@"pdp_ip0"]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : @"0.0.0.0";
}


@end
