#include<stdio.h>
struct process
{
    int waiting_time,arrival_time,Brust_time,Tarrival,Proirty;
};
struct process a[10];
int main()
{
    int n,temp[10],t,count=0,short_p;
    float total_arrival_time,total_waiting_time=0,total_Tarrival=0,Avg_waiting_time,Avg_Tarrival;
    printf("Enter the number of the process\n");
    scanf("%d",&n);
    printf("Enter the arrival time , burst time and priority of the process\n");
    printf("Arrival Time : Brust_time : Proirty\n");
    for(int i=0;i<n;i++)
    {
        scanf("%d%d%d",&a[i].arrival_time,&a[i].Brust_time,&a[i].Proirty);
        temp[i]=a[i].Brust_time;
    } 
    a[9].Proirty=10000;
    for(t=0;count!=n;t++)
    {
        short_p=9;
        for(int i=0;i<n;i++)
        {
            if(a[short_p].Proirty>a[i].Proirty && a[i].arrival_time<=t && a[i].Brust_time>0)
            {
                short_p=i;
            }
        }
        a[short_p].Brust_time=a[short_p].Brust_time-1;
        if(a[short_p].Brust_time==0)
        {
            count++;
            a[short_p].waiting_time=t+1-a[short_p].arrival_time-temp[short_p];
            a[short_p].Tarrival=t+1-a[short_p].arrival_time;
            total_waiting_time=total_waiting_time+a[short_p].waiting_time;
            total_Tarrival=total_Tarrival+a[short_p].Tarrival;       
        }
    }
    Avg_waiting_time=total_waiting_time/n;
    Avg_Tarrival=total_Tarrival/n;
    printf("Process_ID : waiting_time : arrival_time\n");
    for(int i=0;i<n;i++)
    {
        printf("%d\t\t\t%d\t\t\t%d\n",i+1,a[i].waiting_time,a[i].Tarrival);
    }
    printf("Avg waiting time of the process  is %f\n",Avg_waiting_time);
    printf("Avg turn around time of the process is %f\n",Avg_Tarrival);   
    return 0;
}
