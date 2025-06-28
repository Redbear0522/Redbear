package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import user.UserDTO;

public class UserDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	private Connection getConnection() {
	    Connection conn = null;
	    try {
	        Class.forName("org.postgresql.Driver");
	        String url  ="jdbc:postgresql://"
	        		+ "dpg-d1egnpje5dus73bdibt0-a.singapore-postgres.render.com"
	        		+ ":5432/redbearstorage?sslmode=require";
	        String user = "redbearstorage_user";
	        String pass = "3MIkZPNJS880iE9NhM0f5s73EQ3MbcFQ";
	        conn = DriverManager.getConnection(url, user, pass);
	    } catch (ClassNotFoundException cnfe) {
	        System.err.println("PostgreSQL Driver not found!");
	        cnfe.printStackTrace();
	    } catch (SQLException sqle) {
	        sqle.printStackTrace();
	    }
	    return conn;
	}
	 /*
	private Connection getConnection() {
=======
>>>>>>> d7c54c289e5b8ccdde087ed54d1424c17e1b1fe6
		try {
			//1단계
			Class.forName("oracle.jdbc.driver.OracleDriver");
			
			//2단계
<<<<<<< HEAD
			String url = "jdbc:oracle:thin:@58.73.200.225:1521:orcl";
=======
			String url = "jdbc:oracle:thin:@192.168.219.198:1521:orcl";
>>>>>>> d7c54c289e5b8ccdde087ed54d1424c17e1b1fe6
			conn = DriverManager.getConnection(url, "java03", "1234");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
<<<<<<< HEAD
	}*/
	
	private void disconnect() {
        try {
            if (rs != null && !rs.isClosed()) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (pstmt != null && !pstmt.isClosed()) pstmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (conn != null && !conn.isClosed()) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

	public boolean input(UserDTO dto) {
	    String sql = 
	      "INSERT INTO homepage("
	    + " id,pw,name,birth,phone1,phone2,zip,addr1,addr2,gender,greetings"
	    + ") VALUES(?,?,?,?,?,?,?,?,?,?,?)";
	    try ( Connection conn = getConnection();
	          PreparedStatement pstmt = conn.prepareStatement(sql) ) {
	        
	        pstmt.setString(1, dto.getId());
	        pstmt.setString(2, dto.getPw());
	        pstmt.setString(3, dto.getName());
	        pstmt.setString(4, dto.getBirth());
	        pstmt.setString(5, dto.getPhone1());
	        pstmt.setString(6, dto.getPhone2());
	        pstmt.setString(7, dto.getZip());
	        pstmt.setString(8, dto.getAddr1());
	        pstmt.setString(9, dto.getAddr2());
	        pstmt.setInt   (10, dto.getGender());
	        pstmt.setString(11, dto.getGreetings());
	        pstmt.executeUpdate();
	        
	        // 홈페이지이미지 테이블이 있는 경우
	        try ( PreparedStatement img = 
	                conn.prepareStatement(
	                  "INSERT INTO homepageimage(id) VALUES(?)") ) {
	            img.setString(1, dto.getId());
	            img.executeUpdate();
	        }
	        return true;
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}

	public boolean checkid(UserDTO dto) {
		boolean result = false;
		try {
			conn = getConnection();
			// 3단계
			String sql = "select * from homepage where id=? and pw=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getPw());
			// 4단계
			rs = pstmt.executeQuery();
			if (rs.next()) {
				result = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		return result;
	}
	public String findId(UserDTO dto) {
	    String result = null;
	    try {
	        conn = getConnection();
	        String sql = "SELECT id FROM homepage WHERE name=? AND phone2=? AND birth=?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, dto.getName());
	        pstmt.setString(2, dto.getPhone2());
	        pstmt.setString(3, dto.getBirth());

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            result = rs.getString("id"); // ← 여기서 ID를 꺼냄
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        disconnect();
	    }
	    return result; // 찾은 ID 또는 null
	}
	public String findPw(UserDTO dto) {
	    String result = null;
	    try {
	        conn = getConnection();
	        String sql = "SELECT pw FROM homepage WHERE name=? AND phone2=? AND birth=? and id=?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, dto.getName());
	        pstmt.setString(2, dto.getPhone2());
	        pstmt.setString(3, dto.getBirth());
	        pstmt.setString(4, dto.getId());

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            result = rs.getString("pw"); 
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        disconnect();
	    }
	    return result; // 찾은 ID 또는 null
	}

	public UserDTO getInfo(String id) {
		UserDTO dto = null;
		try {
			conn = getConnection();
			String sql = "select * from homepage where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				dto = new UserDTO();
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setBirth(rs.getString("birth"));
				dto.setPhone1(rs.getString("phone1"));
				dto.setPhone2(rs.getString("phone2"));
				dto.setZip(rs.getString("zip"));
				dto.setAddr1(rs.getString("addr1"));
				dto.setAddr2(rs.getString("addr2"));
				dto.setGender(rs.getInt("gender"));
				dto.setGreetings(rs.getString("greetings"));

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {			
		disconnect();
		}
		return dto;
	}

	public void updateProfile(String id, String filename) {
		try {
			conn = getConnection();
			String sql = "update homepage set image=? where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, filename);
			pstmt.setString(2, id);
			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {	
			disconnect();
		}
	}
	
	public String getProfile(String id) {
		String result = "default.jpg";
		try {
			conn = getConnection();
			String spl = "select image from homepageimage where id=?";
			pstmt = conn.prepareStatement(spl);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getString("image");
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		} finally {	
			disconnect();
		}
		
		return result;
	}
	
	public boolean isIdExists(String id) {
		boolean result = false;
		try {
			conn = getConnection();
			String sql = "SELECT id FROM homepage WHERE id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				result = true; // 아이디가 존재함
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		return result;
	}
	public void pwChange(String id, String pw) {
		try {
			conn = getConnection();
			String sql = "update homepage set pw=? where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pw);
			pstmt.setString(2, id);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {	
			disconnect();
		}
	}
	
	public void updateUser(UserDTO dto) {
		try {
			conn = getConnection();
			String sql = "update homepage set name=?, birth=?, phone1=?,phone2=?,"
					+ "gender=?,zip=?,addr1=?,addr2=?,greetings=? where id=? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getBirth());
			pstmt.setString(3, dto.getPhone1());
			pstmt.setString(4, dto.getPhone2());
			pstmt.setInt(5, dto.getGender());
			pstmt.setString(6, dto.getZip());
			pstmt.setString(7, dto.getAddr1());
			pstmt.setString(8, dto.getAddr2());
			pstmt.setString(9, dto.getGreetings());
			pstmt.setString(10, dto.getId());
			pstmt.executeUpdate();
			System.out.println("업데이트 시도: " + dto.getId() + ", " + dto.getPhone1());
			
		}catch(Exception e) {
			System.out.println("Update 오류 발생: " + e.getMessage());
			e.printStackTrace();
		}finally {	
			disconnect();
		}
	
	}
	public void deleteMember(UserDTO dto) {
		try {
		conn = getConnection();
		String sql = "DELETE FROM homepage WHERE id=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, dto.getId());
		pstmt.executeUpdate();
		
		sql = "DELETE FROM homepageimage WHERE id=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, dto.getId());
		pstmt.executeUpdate();
		
	}catch(Exception e) {
		e.printStackTrace();
	}finally {	
		disconnect();
	}
}
	public UserDTO getUserById(String id) {
	    UserDTO vo = null;
	    String sql = "SELECT * FROM homepage WHERE id = ?";
	    try {
	        conn= getConnection();  // DB 연결 (이미 있는 메서드일 것)
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, id);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            vo = new UserDTO();
	            vo.setId(rs.getString("id"));
	            vo.setPw(rs.getString("pw"));
	            vo.setName(rs.getString("name"));
	            // 필요 시 다른 필드도 set 가능
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        disconnect();  // DB 연결 해제
	    }
	    return vo;
	}




}// class end
