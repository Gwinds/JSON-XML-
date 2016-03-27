//
//  ChinaWeatherTableViewController.m
//  天气预报
//
//  Created by doubi on 16/2/25.
//  Copyright © 2016年 doubi. All rights reserved.
//

#import "ChinaWeatherTableViewController.h"
#import "AreaWeatherTableViewController.h"
@interface ChinaWeatherTableViewController ()

@end

@implementation ChinaWeatherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getWeatherInfo];
    [self getWeatherImage];
    UIRefreshControl *refresh=[[UIRefreshControl alloc] init];
    NSAttributedString *str=[[NSAttributedString alloc] initWithString:@"正在拼命加载。。。。" ];
    refresh.attributedTitle=str;
    
    [refresh addTarget:self action:@selector(refreshEvent:) forControlEvents:UIControlEventEditingChanged];
    self.refreshControl=refresh;
    
}
-(void)refreshEvent:(UIRefreshControl *)sender
{
    
    [self getWeatherInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return citys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    CityWeather *temp=[citys objectAtIndex:indexPath.row];
    cell.textLabel.text=temp.cityname;
    NSString *info=[NSString stringWithFormat:@"%@ :%@~%@",temp.stateDetailed,temp.tem1,temp.tem2];
    cell.detailTextLabel.text=info;
    cell.detailTextLabel.textColor=[UIColor blueColor];
    cell.imageView.image=[weatherImage objectForKey:temp.state1];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityWeather *selectedCity=[citys objectAtIndex:indexPath.row];
    UIStoryboard  *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
      AreaWeatherTableViewController  *view=[storyBoard instantiateViewControllerWithIdentifier:@"areaSeg"];
    view.weatherImage=weatherImage;
    view.city=selectedCity;
    view.isCanForward=YES;
    //跳转
    [self.navigationController pushViewController:view animated:YES];




}

-(void)getWeatherInfo
{
    citys=[NSMutableArray array];
    NSURL *url=[NSURL URLWithString:@"http://flash.weather.com.cn/wmaps/xml/china.xml"];
    NSURLSession  *session=[NSURLSession sharedSession];
    NSURLSessionTask *task=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error)
        {
            
            NSLog(@"网络错误");
            dispatch_async(dispatch_get_main_queue(), ^{
                NSAttributedString *str=[[NSAttributedString alloc] initWithString:@"加载失败" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,nil]];
                self.refreshControl.attributedTitle=str;
                if ([self.refreshControl isRefreshing]) {
                    [self.refreshControl endRefreshing];
                }
                
            });
            return;
            
        }
        NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:data];
        xmlParser.delegate=self;
        [xmlParser parse];
        
    }];

    [task resume];
}
-(void)getWeatherImage
{
    NSURL *url;
    weatherImage=[[NSMutableDictionary alloc] init];
    UIImage *image;
    NSData *data;
    for(NSInteger i=0;i<=17;i++)
    {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"http://m.weather.com.cn/img/b%li.gif",i]];
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if(data)
        {
            image=[UIImage imageWithData:data];
            [weatherImage setValue:image forKey:[NSString stringWithFormat:@"%li",i]];
        }
        else
        {
            //给一个默认的显示为下载失败的图片
            ;
        }
      
    
    }



}


#pragma  mark--xml代理
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    [citys removeAllObjects];

}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    if ([elementName isEqualToString:@"city"]) {
        city=[[CityWeather alloc] init];
        NSArray *allkey=[attributeDict allKeys];
        for(NSString *key in allkey)
        {
               [city setValue:[attributeDict objectForKey:key] forKey:key
                ];
            
        }
        [citys addObject:city];
    }
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    
          dispatch_async(dispatch_get_main_queue(), ^{
              
              [self.tableView reloadData];
              if([self.refreshControl isRefreshing]){
                  [self.refreshControl endRefreshing];
              }
              
          });


}
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
         dispatch_async(dispatch_get_main_queue(), ^{
           
             NSAttributedString  *str=[[NSAttributedString alloc] initWithString:@"加载失败" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,nil]];
             self.refreshControl.attributedTitle=str;
             if([self.refreshControl isRefreshing]){
                 [self.refreshControl endRefreshing];
             }
             
         });
    NSLog(@"数据解析错误");
}



@end
