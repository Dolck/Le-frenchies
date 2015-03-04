package test;

import org.junit.*;
import models.*;

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
        DatabaseConn.getPallets();
      }
    });
  }
}
