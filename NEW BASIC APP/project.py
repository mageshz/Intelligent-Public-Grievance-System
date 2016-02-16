from flask import Flask, render_template, request, redirect, jsonify, url_for, flash
from IPGSdb import *

app = Flask(__name__)

@app.route('/')
@app.route('/main')
def showissues():
	return render_template('issues.html')

@app.route('/issues/new/', methods=['GET', 'POST'])
def newIssues():
    if request.method == 'POST':
    	#New Issue = createIssues(I_Author = login_session['U_Id'],I_Title = request.form['I_Title'],I_Content = request.form['I_Content'],I_Lat= request.form['I_Lat'],I_Lng= request.form['I_Lng'],I_Image= request.form['I_Image'],I_AnonFlag= request.form['I_AnonFlag'],I_Type= request.form['I_Type']):
        #newIssues = Issues(name=request.form['name'])
        #flash('New Restaurant %s Successfully Created' % newRestaurant.name)
        return redirect(url_for('showissues'))
    else:
        return render_template('newIssues.html')


@app.route('/issues/<int:I_Id>/edit/', methods=['GET', 'POST'])
def editIssues(I_Id):
    editedRestaurant = session.query(
        Restaurant).filter_by(id=restaurant_id).one()
    if request.method == 'POST':
        if request.form['name']:
            editedRestaurant.name = request.form['name']
            flash('Restaurant Successfully Edited %s' % editedRestaurant.name)
            return redirect(url_for('showRestaurants'))
    else:
        return render_template('editIssues.html', restaurant=editedRestaurant )


# Delete a issue
@app.route('/issues/<int:I_Id>/delete/', methods=['GET', 'POST'])
def deleteIssues(I_Id):
    restaurantToDelete = session.query(
        Restaurant).filter_by(id=restaurant_id).one()
    if request.method == 'POST':
        session.delete(restaurantToDelete)
        flash('%s Successfully Deleted' % restaurantToDelete.name)
        session.commit()
        return redirect(url_for('showRestaurants', restaurant_id=restaurant_id))
    else:
        return render_template('deleteRestaurant.html', restaurant=restaurantToDelete)


if __name__ == '__main__':
    app.secret_key = 'super_secret_key'
    app.debug = True
    app.run(host='0.0.0.0', port=5000)
