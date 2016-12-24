#include <stdio.h>
#include <stdlib.h>
#include<time.h>
void display(int *a,int n);
void generate_random_state(int *a,int n);
int find_cost(int *a,int n);
int find_next_best_move(int *a,int n);
FILE *fp;
int main()
{
    FILE *fo;
    int tes;
    int moves=0,Random_restart=0;
    fo = fopen("input.txt","r");

    fp = fopen("output.txt","w");
    int n=8,result=0; //Set N for N-Queens
    fscanf(fo,"%d",&n);
    int *a;
    int i;
    a = (int*) calloc(n,sizeof(int));
    generate_random_state(a,n);
    srand ( time(NULL) );
    tes = rand();
    while(find_cost(a,n)!=0)
    {
        result = find_next_best_move(a,n);
        if(result==0)
        {
            //If we arrive at local maxima
            Random_restart++;
            generate_random_state(a,n);
        }
        moves++;
    }
    fprintf(fp,"Steps of climbing: %d\nRandom Restart required: %d\nfinal State:\n",moves,Random_restart);
    display(a,n);
    return 0;
}
void display(int *a,int n)
{
    int i,j;
    for(i=0;i<n;i++)
    fprintf(fp," %d ",a[i]);
    fprintf(fp,"\n");
    for(i=0;i<n;i++)
    {
        for(j=0;j<n;j++)
        {
            if(a[j]==i)
                fprintf(fp,"|Q|");
            else
                fprintf(fp,"|_|");
        }
        fprintf(fp,"\n");
    }


}

void generate_random_state(int *a,int n)
{
    int i;
    for(i=0;i<n;i++)
    {
            a[i] = rand()%(n);
    }

}

int find_next_best_move(int *a,int n)
{
 int cost,i,*move,*column,ptr=0,ptr1=0,*succ_cost,selected_move=0,initial_cost=0,j,temp;
 int *succ_cost1,*move1,*column1;

 move = (int*) calloc(2*n,sizeof(int));
 column = (int*) calloc(2*n,sizeof(int));
 succ_cost = (int*) calloc(2*n,sizeof(int));
//Find then successor with minimum cost.
cost = find_cost(a,n);
initial_cost = find_cost(a,n);
    for(i=0;i<n;i++)
    {
        if(a[i]!=0)
        {
            //Move queen in column i up by 1 space
            temp = a[i];
            for(j=a[i];j>0;j--)
            {
                a[i]--;
            //    display(a,n);
                if(cost>=find_cost(a,n)&&find_cost(a,n)!=initial_cost)
                {
                    cost = find_cost(a,n);
                    succ_cost[ptr] = find_cost(a,n);
                    move[ptr] = (temp - a[i])*-1;
                    column[ptr++] = i;
                }
            }
            a[i] = temp;
        }
        if(a[i]!=n-1)
        {
            //Move queen in column i down by 1 space
            temp = a[i];
            for(j=a[i];j<n;j++)
            {
                a[i]++;
             //   display(a,n);
                if(cost>=find_cost(a,n)&&find_cost(a,n)!=initial_cost)
                {
                    cost = find_cost(a,n);
                    succ_cost[ptr] = find_cost(a,n);
                     move[ptr] = a[i] - temp;
                    column[ptr++] = i;
                }
            }
            a[i] = temp;
        }
    }
    if(ptr==0)
        return 0;
    else
    {
        move1 = (int*) calloc(2*n,sizeof(int));
        column1 = (int*) calloc(2*n,sizeof(int));
        succ_cost1 = (int*) calloc(2*n,sizeof(int));
        for(i=0;i<ptr;i++)
        {
            if(succ_cost[i]==cost)
            {
                move1[ptr1] = move[i];
                column1[ptr1] = column[i];
                succ_cost1[ptr1++] = succ_cost[i];
            }
        }
        if(ptr1>1)
            selected_move = rand() % (ptr1+1);
        else
            selected_move = 0;
        a[column[selected_move]] = a[column[selected_move]] + move[selected_move];
        return 1;
    }
}

int find_cost(int *a,int n)
{
    int cost = 0,i,j,found_row,found_col_up,found_col_down;
    for(i=0;i<n-1;i++)
    {
       for(j=i+1;j<=n-1;j++)
       {
           if(a[i]==a[j])
           {
                cost++;
           }

           if(a[i]==(a[j] + (j-i)) )
           {
               cost++;
           }

           if(a[i]==(a[j] - (j-i)) )
           {
               cost++;
           }
       }
    }
    return cost;
}
