package com.example.JavaFileCopier;

import java.io.IOException;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Hello world!
 *
 */
public class App {
	public static void main(String[] args) throws IOException, InterruptedException {
		System.out.println("Hello World!");
		AbstractApplicationContext ctx = new ClassPathXmlApplicationContext("applicationContext.xml");
		ctx.start();
		Thread.sleep(5 * 60 * 1000);
		ctx.stop();
	}

}
