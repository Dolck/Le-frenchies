package test;

import org.junit.*;
import models.*;
import java.util.*;
import scala.Enumeration;

import play.mvc.*;
import play.test.*;
import play.libs.F.*;

import static play.test.Helpers.*;
import static org.fest.assertions.Assertions.*;

public class DatabaseTest {

  @Test 
  public void simpleCheck() {
    running(fakeApplication(), new Runnable() {
      public void run() {
        System.out.println(DatabaseConn.getPallets(new GregorianCalendar(1990, 1, 1).getTime(), new GregorianCalendar(2025, 1, 1).getTime(), "", PalletStatus.free()));
      }
    });
  }
}
