import java.util.Arrays;

import org.jacop.constraints.*;
import org.jacop.core.*;
import org.jacop.search.*;

public class lab1 {

	public static void main(String[] args) {
		Store store = new Store();

		/*
		 * Beef Patty 	50 	17 	220 $0.25 
		 * Bun 			330 9 	260 $0.15 
		 * Cheese 		310 6 	70 	$0.10
		 * Onions 		1 	2 	10 	$0.09 
		 * Pickles		260 0 	5 	$0.03 
		 * Lettuce 		3 	0 	4 	$0.04 
		 * Ketchup 		160 0 	20 	$0.02 
		 * Tomato 		3 	0 	9 	$0.04
		 */

		IntVar bp = new IntVar(store, "Beef Patty", 0, 9);
		IntVar bun = new IntVar(store, "Bun", 0, 10);
		IntVar c = new IntVar(store, "Cheese", 0, 10);
		IntVar o = new IntVar(store, "Onion", 0, 75);
		IntVar p = new IntVar(store, "Pickles", 0, 12);
		IntVar l = new IntVar(store, "Lettuce", 0, 750);
		IntVar k = new IntVar(store, "Ketchup", 0, 19);
		IntVar t = new IntVar(store, "Tomato", 0, 334);

		IntVar[] vars = { bp, bun, c, o, p, l, k, t };

		store.impose(new XeqY(l, k));
		store.impose(new XeqY(p, t));

		// Sodium
		store.impose(new Linear(store,
				new IntVar[] { bp, bun, c, o, p, l, k, t }, new int[] { 50,
						330, 310, 1, 260, 3, 160, 3 }, "<=", 3000));
		// Fat
		store.impose(new Linear(store,
				new IntVar[] { bp, bun, c, o, p, l, k, t }, new int[] { 17, 9,
						6, 2, 0, 0, 0, 0 }, "<=", 150));
		// Calories
		store.impose(new Linear(store,
				new IntVar[] { bp, bun, c, o, p, l, k, t }, new int[] { 220,
						260, 70, 10, 5, 4, 20, 9 }, "<=", 3000));
		// Cost
		store.impose(new Linear(store,
				new IntVar[] { bp, bun, c, o, p, l, k, t }, new int[] { -25,
						-15, -10, -9, -3, -4, -2, -4 }, "<", 0));

		Search<IntVar> label = new DepthFirstSearch<IntVar>();

		SelectChoicePoint<IntVar> select = new SimpleSelect<IntVar>(vars,
				new SmallestDomain<IntVar>(), new IndomainMin<IntVar>());
		
		label.setSolutionListener(new PrintOutListener<IntVar>());
		label.getSolutionListener().searchAll(true);
		
		boolean result = label.labeling(store, select);
		
		if(result)
			System.out.println("Solution: " + Arrays.asList(vars));
		else
			System.out.println("NOOOO!");
	}

}
