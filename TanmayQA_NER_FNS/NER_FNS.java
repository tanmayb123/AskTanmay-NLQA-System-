import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import com.ibm.watson.developer_cloud.alchemy.v1.AlchemyLanguage;
import com.ibm.watson.developer_cloud.alchemy.v1.model.Entities;
import com.ibm.watson.developer_cloud.alchemy.v1.model.Entity;
import com.ibm.watson.developer_cloud.alchemy.v1.model.LanguageSelection;

/*
 * 
 * This is *very-very-very* old code from a small version of AskTanmay.
 * However, other bug fixes prioritized over cleaning up this code, so this remains unorganized from Alpha version.
 * If you'd like to contribute to the repo, and clean the code, please do!
 * This is intended to be cleaned by version 2.2, and translated to Swift by 3.
 * 
 * This is how the arguments should look when running this code: <ATD Result> "[candidate answer]" [candidate answer score] "[candidate answer]" [candidate answer score] ...
 * Example: 'java -jar <jarfile>.jar PERSON "Stephen Hillenburg" 50 "Tom Kenny" 25 "Nickelodeon" 10'
 * You can understand more by looking at the main function.
 * 
 * NOTE: Most of this code is from http://www.tutorialspoint.com/java/java_multithreading.htm
 * 
 */

public class NER_FNS {
	
	public String typeLooking = "";

	class RunnableDemo implements Runnable {
		private Thread t;
		private String threadName;
		private int threadScore;
		private AlchemyLanguage service;
	
		RunnableDemo(String name, int score, AlchemyLanguage serv) {
		 	threadName = name;
		 	threadScore = score;
			service = serv;
			service.setLanguage(LanguageSelection.ENGLISH);
			 //System.out.println("Creating " +  threadName );
		}
		public void run() {
			//System.out.println("Running " +  threadName );
			try {
				service.setApiKey("<ALCHEMYAPI KEY>");

				Map<String, Object> params = new HashMap<String, Object>();
				params.put(AlchemyLanguage.TEXT, threadName);
				
				Entities ents = service.getEntities(params);
				
				ArrayList<Entity> rents = (ArrayList<Entity>) ents.getEntities();
				
				ArrayList<String> finalTexts = new ArrayList<String>();
				
				ArrayList<String> fullNameScore = new ArrayList<String>();
				
				fullNameScore.addAll(Arrays.asList("ORGANIZATION", "PERSON"));
				
				ArrayList<String> ORGS = new ArrayList<String>();
				ArrayList<String> PERS = new ArrayList<String>();
				ArrayList<String> LOCS = new ArrayList<String>();
				
				ORGS.addAll(Arrays.asList("Organization", "Company", "Facility"));
				PERS.addAll(Arrays.asList("Person"));
				LOCS.addAll(Arrays.asList("City", "Continent", "Country", "GeographicFeature", "StateOrCounty"));
				
				boolean specific = false;
				if (ORGS.contains(typeLooking) || PERS.contains(typeLooking) || LOCS.contains(typeLooking)) {
					specific = true;
				}

				for (Entity i : rents) {
					boolean add = false;
					if (PERS.contains(i.getType()) && typeLooking.equals("PERSON")) {
						add = true;
					} else if (ORGS.contains(i.getType()) && typeLooking.equals("ORGANIZATION")) {
						add = true;
					} else if (LOCS.contains(i.getType()) && typeLooking.equals("GPE")) {
						add = true;
					} else if (specific == true) {
						if (typeLooking.equals(i.getType())) {
							add = true;
						}
					}
					if (add) {
						finalTexts.add(i.getText());
					}
				}
				
				for (String finalText : finalTexts) {
					// Full Name Scoring
					finalText = finalText + "\n";
					int score = 15;
					if (fullNameScore.contains(typeLooking)) {
						Boolean contains = finalText.contains(" ");
						Boolean upper = !finalText.toLowerCase().equals(finalText);
						if (!contains) score -= 10;
						if (!upper) score -= 5;
					}
					finalText = finalText + "" + (threadScore * score);
					System.out.println(finalText);
				}

				// Let the thread sleep for a while.
				Thread.sleep(50);
	  		} catch (Exception e) {
				//System.out.println("Thread " +  threadName + " interrupted.");
	  		}
	  		//System.out.println("Thread " +  threadName + " exiting.");
		}
	
		public void start ()
		{
			//System.out.println("Starting " +  threadName );
			if (t == null)
			{
				t = new Thread (this, threadName);
				t.start ();
			}
		}

	}

	public int activeThreads() {
		int nbRunning = 0;
		for (Thread t : Thread.getAllStackTraces().keySet()) {
    		if (t.getState()==Thread.State.RUNNABLE) nbRunning++;
		}
		return nbRunning;
	}

	public NER_FNS(String[] cands) {
		AlchemyLanguage serviceTemplate = new AlchemyLanguage();
		for (int i = 0; i < cands.length; i++) {
			if (i % 2 == 0 && i != 0) {
				String cand = cands[i-1];
				RunnableDemo R1 = new RunnableDemo(cand, Integer.parseInt(cands[i]), serviceTemplate);
      				R1.start();
			} else if (i == 0) {
				typeLooking = cands[i];
			}
		}
	}

	public static void main(String[] args) {
		new NER_FNS(args);
	}
	
}

