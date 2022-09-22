import java.io.*;
import java.net.*;
import java.lang.*;
public class Eserver{
public static void main(String args[])throws IOException{
ServerSocket s=null;
String line;
DataInputStream is;
PrintStream ps;
Socket c=null;
try{
s=new ServerSocket(8080);
}
catch(IOException e){
System.out.println(e);
}
try{
c=s.accept();
is=new DataInputStream(c.getInputStream());
ps=new PrintStream(c.getOutputStream());
while(true){
line=is.readLine();
System.out.println("msg received and sent back to client");
ps.println(line);
}}
catch(IOException e){
System.out.println(e);
}}}
