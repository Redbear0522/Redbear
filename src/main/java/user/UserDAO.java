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

	/*private Connection getConnection() {
		try {
			//1단계
			Class.forName("oracle.jdbc.driver.OracleDriver");
			
			//2단계
			//String url = "jdbc:oracle:thin:@192.168.219.198:1521:orcl";
			String url = "jdbc:oracle:thin:@58.73.200.225:1521:orcl";
			conn = DriverManager.getConnection(url, "java03", "1234");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}*/
	private Connection getConnection() throws Exception {
		 String db_host = System.getenv("DB_HOST");
		    String db_name = System.getenv("DB_NAME");
		    String db_user = System.getenv("DB_USER");
		    String db_pass = System.getenv("DB_PASS");

		    // 2. Render 환경(DB_HOST 변수가 존재할 때)인지 확인합니다.
		    if (db_host != null && !db_host.isEmpty()) {
		        // PostgreSQL 용 JDBC URL을 조립합니다. SSL 옵션을 포함합니다.
		        String dbUrl = "jdbc:postgresql://" + db_host + "/" + db_name + "?sslmode=require";
		        Class.forName("org.postgresql.Driver");
		        // URL, 사용자 이름, 비밀번호를 각각 인자로 전달하여 연결합니다.
		        return DriverManager.getConnection(dbUrl, db_user, db_pass);
		    } else {
		        // 3. 내 PC(로컬) 환경일 때 (Oracle)
		        Class.forName("oracle.jdbc.driver.OracleDriver");
		        return DriverManager.getConnection("jdbc:oracle:thin:@192.168.219.198:1521:orcl", "team01", "1234");
		    }
		}
	
	private void disconnect() {
        try {if (rs != null && !rs.isClosed()) rs.close();        } catch (SQLException e) {            e.printStackTrace();        }
        try {if (pstmt != null && !pstmt.isClosed()) pstmt.close();        } catch (SQLException e) {            e.printStackTrace();        }
        try {if (conn != null && !conn.isClosed()) conn.close();        } catch (SQLException e) {            e.printStackTrace();        }
    }

	public boolean input(UserDTO dto) {
		boolean success = false; 
		try {
			conn = getConnection();
			// 3단계 SQL Query문 작성
		    
		        String sql = "INSERT INTO homepage values(?,?,?,?,?,?,?,?,?,?,?,CURRENT_TIMESTAMP)";
		        pstmt = conn.prepareStatement(sql);
			//Statement 반복적으로 매번 실행 /PrepareStatement 이미 실행된 정보를 가지고 실행 / queryStatement 함수 실행할때 실행			
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getPw());
			pstmt.setString(3, dto.getName());
			pstmt.setString(4, dto.getBirth());
			pstmt.setString(5, dto.getPhone1());
			pstmt.setString(6, dto.getPhone2());
			pstmt.setString(7, dto.getZip());
			pstmt.setString(8, dto.getAddr1());
			pstmt.setString(9, dto.getAddr2());
			pstmt.setInt(10, dto.getGender());
			pstmt.setString(11, dto.getGreetings());
			
			// 4 단계 SQL Query문 실행
			int result1 = pstmt.executeUpdate(); // 첫 번째 insert 결과

	        sql = "insert into homepageimage(id) values(?)";
	        pstmt = conn.prepareStatement(sql);

	        pstmt.setString(1, dto.getId());
	        int result2 = pstmt.executeUpdate(); // 두 번째 insert 결과

	        // [수정] 두 쿼리가 모두 성공적으로 실행되었는지 확인
	        if (result1 > 0 && result2 > 0) {
	            success = true;
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        disconnect();
	    }
	    // [수정] return false -> return success
	    return success;
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
	        // [수정] homepage -> homepageimage
	        // 프로필 이미지는 homepageimage 테이블에서 관리하므로 대상을 수정합니다.
			String sql = "update homepageimage set image=? where id=?";
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
