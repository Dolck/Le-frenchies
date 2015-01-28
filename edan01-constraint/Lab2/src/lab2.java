import java.util.ArrayList;
import java.util.Arrays;

import org.jacop.constraints.*;
import org.jacop.core.*;
import org.jacop.search.*;

public class lab2 {
	public static void main(String[] args) {
		Store store = new Store();

		IntVar[] week = { new IntVar(store, "Monday", 5, 18),
				new IntVar(store, "Tuesday", 7, 18),
				new IntVar(store, "Wednesday", 7, 18),
				new IntVar(store, "Thursday", 10, 18),
				new IntVar(store, "Friday", 16, 18),
				new IntVar(store, "Saturday", 18, 18),
				new IntVar(store, "Sunday", 12, 18) };
		
		IntVar[] ptStartDay = { new IntVar(store, "pMonday", 0, 18),
				new IntVar(store, "pTuesday", 0, 18),
				new IntVar(store, "pWednesday", 0, 18),
				new IntVar(store, "pThursday", 0, 18),
				new IntVar(store, "pFriday", 0, 18),
				new IntVar(store, "pSaturday", 0, 18),
				new IntVar(store, "pSunday", 0, 18) };
		
		IntVar[] ftStartDay = { new IntVar(store, "fMonday", 0, 18),
				new IntVar(store, "fTuesday", 0, 18),
				new IntVar(store, "fWednesday", 0, 18),
				new IntVar(store, "fThursday", 0, 18),
				new IntVar(store, "fFriday", 0, 18),
				new IntVar(store, "fSaturday", 0, 18),
				new IntVar(store, "fSunday", 0, 18) };
		
		IntVar[] vars = concat(ptStartDay, ftStartDay);
		
		int pLen = 2;
		int fLen = 5;
		
		for(int i = 0; i < 7; i++){
			ArrayList<IntVar> workers = new ArrayList<IntVar>();
			for(int j = (i - pLen + 7)%7; j != i; j = (j+1)%7){
				int t = (j+1)%7;
				workers.add(ptStartDay[t]);
				
			}
			
			for(int j = (i - fLen + 7)%7; j != i; j = (j+1)%7){
				int t = (j+1)%7;
				workers.add(ftStartDay[t]);
			}
			
			store.impose(new Sum(workers, week[i]));
		}
		
		IntVar totSalary = new IntVar(store, "total salary", 0, 100000);
		IntVar ptTotSalary = new IntVar(store, "parttime total salary", 0, 100000);
		IntVar ftTotSalary = new IntVar(store, "fulltime total salary", 0, 100000);

		store.impose(new SumWeight(ptStartDay, new int[]{300,300,300,300,300,300,300}, ptTotSalary));
		store.impose(new SumWeight(ftStartDay, new int[]{500,500,500,500,500,500,500}, ftTotSalary));
		store.impose(new XplusYeqZ(ptTotSalary,ftTotSalary, totSalary));
		
		
		Search<IntVar> label = new DepthFirstSearch<IntVar>();

		SelectChoicePoint<IntVar> select = new SimpleSelect<IntVar>(vars,
				new SmallestDomain<IntVar>(), new IndomainMin<IntVar>());

		label.setSolutionListener(new PrintOutListener<IntVar>());
		label.getSolutionListener().searchAll(true);

		boolean result = label.labeling(store, select, totSalary);

		if (result) {
			System.out.println("Solution: " + Arrays.asList(vars));
			System.out.println("Total salary: " + totSalary);
		} else {
			System.out.println("NOOOO!");
		}

	}
	
	private static IntVar[] concat(IntVar[] a, IntVar[] b) {
		   int aLen = a.length;
		   int bLen = b.length;
		   IntVar[] c= new IntVar[aLen+bLen];
		   System.arraycopy(a, 0, c, 0, aLen);
		   System.arraycopy(b, 0, c, aLen, bLen);
		   return c;
		}

}
