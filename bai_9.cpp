#include<stdio.h>
int SNT (int n , int u )
{
	if(n==1)
	  return 0;
	if(n==u)
	 return 1;
	else
	  {
	  	if(n%u==0)
	  	  return 0;
	  	else
		   return SNT(n,u+1);  
			  }  	  
}
main()
{
	int so,su;
	scanf("%d",&so);
	if(SNT(so,2)==1)
	   printf(" La so nguyen to");
	else
	     printf(" Khong phai la so ng to");   
}
